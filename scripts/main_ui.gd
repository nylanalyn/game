extends Control

@onready var game_manager = $"/root/GameManager"

# UI References
@onready var dialogue_box = $DialogueBox
@onready var speaker_label = $DialogueBox/SpeakerLabel
@onready var dialogue_text = $DialogueBox/DialogueText
@onready var stats_panel = $StatsPanel
@onready var picture_frame = $PictureFrame
@onready var picture_display = $PictureFrame/PictureDisplay
@onready var fullscreen_picture = $FullscreenPicture
@onready var choice_container = $ChoiceContainer

var is_fullscreen = false
var current_texture: Texture2D = null

func _ready():
	# Connect to game manager signals
	game_manager.stats_updated.connect(_on_stats_updated)
	game_manager.dialogue_updated.connect(_on_dialogue_updated)
	game_manager.image_updated.connect(_on_image_updated)
	game_manager.choices_presented.connect(_on_choices_presented)
	game_manager.phase_changed.connect(_on_phase_changed)

	# Initialize UI
	fullscreen_picture.visible = false
	update_stats_display()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		if choice_container.get_child_count() == 0:
			game_manager.advance_story()

	# Toggle fullscreen picture with space or F key
	if event.is_action_pressed("ui_select") or (event is InputEventKey and event.keycode == KEY_F and event.pressed):
		toggle_fullscreen_picture()

func _on_dialogue_updated(speaker: String, text: String):
	speaker_label.text = speaker
	dialogue_text.text = text
	clear_choices()

func _on_image_updated(image_path: String):
	var texture = load(image_path) as Texture2D
	if texture:
		current_texture = texture
		picture_display.texture = texture
		fullscreen_picture.texture = texture

func _on_stats_updated():
	update_stats_display()

func update_stats_display():
	var stats = game_manager.player_stats
	var stats_text = "[b]%s[/b]\n\n" % stats["name"]
	stats_text += "Level: %d\n\n" % stats["level"]
	stats_text += "Health: %d\n" % stats["health"]
	stats_text += "STR: %d\n" % stats["strength"]
	stats_text += "DEX: %d\n" % stats["dexterity"]
	stats_text += "MAG: %d\n\n" % stats["magic"]

	# Show companion friendships
	stats_text += "[b]Companions[/b]\n"
	for comp_id in game_manager.companions:
		var comp = game_manager.companions[comp_id]
		stats_text += "%s: %d/10\n" % [comp["name"], comp["friendship"]]

	$StatsPanel/StatsText.text = stats_text

func _on_choices_presented(choices: Array):
	clear_choices()
	for i in range(choices.size()):
		var button = Button.new()
		button.text = choices[i]
		button.pressed.connect(_on_choice_selected.bind(i))
		choice_container.add_child(button)

func _on_choice_selected(choice_index: int):
	# Check if this is a companion selection choice (from hub)
	if game_manager.game_phase == "hub":
		match choice_index:
			0:
				game_manager.select_companion("orc")
			1:
				game_manager.select_companion("catgirl")
			2:
				game_manager.select_companion("human")
			3:
				game_manager.select_companion("solo")

		# Start dungeon run
		get_tree().change_scene_to_file("res://scenes/minigames/shmup.tscn")
	else:
		game_manager.make_choice(choice_index)

func clear_choices():
	for child in choice_container.get_children():
		child.queue_free()

func toggle_fullscreen_picture():
	if current_texture == null:
		return

	is_fullscreen = !is_fullscreen
	fullscreen_picture.visible = is_fullscreen

	# Hide other UI when in fullscreen mode
	dialogue_box.visible = !is_fullscreen
	stats_panel.visible = !is_fullscreen
	picture_frame.visible = !is_fullscreen
	choice_container.visible = !is_fullscreen

func _on_phase_changed(new_phase: String):
	# Handle phase-specific UI changes
	match new_phase:
		"dungeon":
			# Switch to dungeon scene (handled by choice selection)
			pass
		"game_over":
			# Show game over
			speaker_label.text = "Game Over"
			dialogue_text.text = "You have failed. The magic path offers no second chances..."
