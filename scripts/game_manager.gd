extends Node

# Player stats
var player_stats = {
	"name": "Player",
	"health": 100,
	"max_health": 100,
	"strength": 10,
	"dexterity": 10,
	"magic": 10,
	"level": 1
}

# Companion system
var companions = {
	"orc": {
		"name": "Kara",
		"friendship": 0,
		"max_friendship": 10,
		"stat_bonus": "strength",
		"bonus_per_level": 5,
		"available": true,
		"story_unlocked": 0
	},
	"catgirl": {
		"name": "Miko",
		"friendship": 0,
		"max_friendship": 10,
		"stat_bonus": "dexterity",
		"bonus_per_level": 5,
		"available": true,
		"story_unlocked": 0
	},
	"human": {
		"name": "Sarah",
		"friendship": 0,
		"max_friendship": 10,
		"stat_bonus": "health",
		"bonus_per_level": 10,
		"available": true,
		"story_unlocked": 0
	}
}

# Game progression
var dungeon_runs_completed = 0
var current_companion = ""  # Which companion is selected for current run
var game_phase = "intro"  # intro, hub, dungeon, interaction, ending

# Story system
var current_scene = ""
var current_image = ""
var story_position = 0
var story_data = []

# Signals for UI updates
signal stats_updated
signal dialogue_updated(speaker: String, text: String)
signal image_updated(image_path: String)
signal choices_presented(choices: Array)
signal companion_updated
signal phase_changed(new_phase: String)
signal dungeon_complete(success: bool)

func _ready():
	# Start with intro sequence
	change_phase("intro")
	load_story("res://story/intro.json")

func load_story(path: String):
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		var json_string = file.get_as_text()
		file.close()

		var json = JSON.new()
		var error = json.parse(json_string)
		if error == OK:
			story_data = json.data
			story_position = 0
			advance_story()
		else:
			push_error("Failed to parse story file: " + path)
	else:
		push_error("Story file not found: " + path)

func advance_story():
	if story_position >= story_data.size():
		print("Story complete!")
		return

	var entry = story_data[story_position]

	# Handle different entry types
	match entry.get("type", "dialogue"):
		"dialogue":
			dialogue_updated.emit(entry.get("speaker", ""), entry.get("text", ""))
			if entry.has("image"):
				image_updated.emit(entry["image"])

		"choice":
			choices_presented.emit(entry.get("choices", []))

		"stat_change":
			apply_stat_change(entry)

		"scene_change":
			current_scene = entry.get("scene", "")

	story_position += 1

func apply_stat_change(change_data: Dictionary):
	for stat in change_data.get("stats", {}):
		if player_stats.has(stat):
			player_stats[stat] += change_data["stats"][stat]
	stats_updated.emit()

func make_choice(choice_index: int):
	# Handle choice logic - could jump to different story positions
	advance_story()

func update_stat(stat_name: String, value: int):
	if player_stats.has(stat_name):
		player_stats[stat_name] = value
		stats_updated.emit()

func modify_stat(stat_name: String, delta: int):
	if player_stats.has(stat_name):
		player_stats[stat_name] += delta
		stats_updated.emit()

# Phase management
func change_phase(new_phase: String):
	game_phase = new_phase
	phase_changed.emit(new_phase)

	match new_phase:
		"hub":
			load_story("res://story/hub.json")
		"ending":
			load_story("res://story/ending.json")

# Companion system
func select_companion(companion_id: String):
	if companion_id == "solo":
		current_companion = "solo"
	elif companions.has(companion_id) and companions[companion_id]["available"]:
		current_companion = companion_id
		apply_companion_bonuses()
	companion_updated.emit()

func apply_companion_bonuses():
	# Reset to base stats first (you'd want to store base stats separately in production)
	# For now, we'll just apply the bonus
	if current_companion != "" and current_companion != "solo":
		var comp = companions[current_companion]
		var stat_name = comp["stat_bonus"]
		var bonus = comp["friendship"] * comp["bonus_per_level"]

		if player_stats.has(stat_name):
			player_stats[stat_name] += bonus
		stats_updated.emit()

func increase_friendship(companion_id: String, amount: int = 1):
	if companions.has(companion_id):
		var comp = companions[companion_id]
		comp["friendship"] = min(comp["friendship"] + amount, comp["max_friendship"])

		# Unlock new story segment
		if comp["friendship"] > comp["story_unlocked"]:
			comp["story_unlocked"] = comp["friendship"]
			load_companion_story(companion_id, comp["friendship"])

		companion_updated.emit()
		stats_updated.emit()

func load_companion_story(companion_id: String, friendship_level: int):
	var story_path = "res://story/companions/%s_level_%d.json" % [companion_id, friendship_level]
	if FileAccess.file_exists(story_path):
		change_phase("interaction")
		load_story(story_path)
	else:
		# No story for this level, return to hub
		change_phase("hub")

func companion_becomes_unavailable(companion_id: String, rounds: int = 3):
	if companions.has(companion_id):
		companions[companion_id]["available"] = false
		# In a full implementation, you'd use a timer to make them available again

func all_companions_maxed() -> bool:
	for comp_id in companions:
		if companions[comp_id]["friendship"] < companions[comp_id]["max_friendship"]:
			return false
	return true

# Dungeon system
func start_dungeon_run():
	change_phase("dungeon")
	# This will trigger the minigame scene to load

func complete_dungeon_run(success: bool):
	dungeon_runs_completed += 1

	if success:
		# Give friendship if with companion
		if current_companion != "" and current_companion != "solo":
			increase_friendship(current_companion, 1)
	else:
		# Failed - companion becomes unavailable
		if current_companion != "" and current_companion != "solo":
			companion_becomes_unavailable(current_companion, 3)
		elif current_companion == "solo":
			# Game over on magic path
			change_phase("game_over")
			return

	dungeon_complete.emit(success)

	# Check if ending is unlocked
	if all_companions_maxed():
		change_phase("ending")
	else:
		change_phase("hub")
