extends Node2D

@onready var game_manager = $"/root/GameManager"

# Game state
var player_health: int = 100
var enemies_remaining: int = 10
var enemies_defeated: int = 0
var current_wave: int = 1

# Player variables
var player_position: Vector2
var attack_cooldown: float = 0.0
var base_attack_speed: float = 1.0  # attacks per second
var attack_damage: int = 10

# Enemy spawn
var spawn_timer: float = 0.0
var spawn_interval: float = 2.0

# References
@onready var player_sprite = $Player
@onready var player_area = $Player/Area2D
@onready var enemy_container = $Enemies
@onready var ui = $UI

# Preload enemy scene
var enemy_scene = preload("res://scenes/minigames/enemy.tscn")

func _ready():
	player_position = Vector2(960, 900)  # Bottom center
	player_sprite.position = player_position

	# Set up based on game manager stats and companion
	setup_player_stats()
	setup_wave()

	# Connect signals
	player_area.area_entered.connect(_on_player_hit)

func setup_player_stats():
	var stats = game_manager.player_stats
	var companion = game_manager.current_companion

	# Base health from stats
	player_health = stats["health"]

	# Base damage from strength
	attack_damage = 10 + (stats["strength"] / 2)

	# Attack speed from dexterity
	base_attack_speed = 1.0 + (stats["dexterity"] / 20.0)

	# Apply companion bonuses
	if companion == "orc":
		attack_damage *= 1.5  # Kara boosts damage
	elif companion == "catgirl":
		base_attack_speed *= 1.5  # Miko boosts attack speed
	elif companion == "human":
		player_health *= 1.3  # Sarah boosts survivability
	# Solo path has no bonuses but more magic damage
	elif companion == "solo":
		# Magic path - powerful but fragile
		attack_damage *= 2.0
		player_health *= 0.5

	update_ui()

func setup_wave():
	# Determine enemies based on dungeon runs completed
	var runs = game_manager.dungeon_runs_completed

	if runs < 2:
		enemies_remaining = 10
		spawn_interval = 2.0
	elif runs < 4:
		enemies_remaining = 10
		spawn_interval = 1.5
	elif runs == 4:
		enemies_remaining = 20  # Wave 3 doubles enemies
		spawn_interval = 1.2
	else:
		# Scales up
		enemies_remaining = 20 + (runs - 4) * 5
		spawn_interval = max(0.5, 1.5 - (runs * 0.1))

	current_wave = min(runs + 1, 10)

func _process(delta):
	# Handle player movement
	handle_player_movement(delta)

	# Handle attacking
	handle_attacking(delta)

	# Spawn enemies
	handle_enemy_spawning(delta)

	# Check win/loss conditions
	check_game_state()

func handle_player_movement(delta):
	var move_speed = 400.0 + (game_manager.player_stats["dexterity"] * 2.0)
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()
		player_position += direction * move_speed * delta

		# Clamp to screen
		player_position.x = clamp(player_position.x, 50, 1870)
		player_position.y = clamp(player_position.y, 50, 1030)

		player_sprite.position = player_position

func handle_attacking(delta):
	attack_cooldown -= delta

	if Input.is_action_pressed("ui_accept") or Input.is_action_pressed("ui_select"):
		if attack_cooldown <= 0:
			fire_projectile()
			attack_cooldown = 1.0 / base_attack_speed

func fire_projectile():
	# Find closest enemy
	var closest_enemy = find_closest_enemy()
	if closest_enemy:
		var projectile = create_projectile(player_position, closest_enemy.position)
		add_child(projectile)

func find_closest_enemy():
	var closest = null
	var closest_dist = 999999.0

	for enemy in enemy_container.get_children():
		var dist = player_position.distance_to(enemy.position)
		if dist < closest_dist:
			closest_dist = dist
			closest = enemy

	return closest

func create_projectile(from: Vector2, to: Vector2):
	var projectile = Area2D.new()
	var sprite = Sprite2D.new()
	var collision = CollisionShape2D.new()
	var shape = CircleShape2D.new()

	shape.radius = 10
	collision.shape = shape

	projectile.add_child(sprite)
	projectile.add_child(collision)
	projectile.position = from

	# Simple white circle for projectile
	sprite.modulate = Color.WHITE

	# Store target and damage
	projectile.set_meta("damage", attack_damage)
	projectile.set_meta("target", to)
	projectile.set_meta("speed", 800.0)
	projectile.area_entered.connect(_on_projectile_hit.bind(projectile))

	return projectile

func _on_projectile_hit(area: Area2D, projectile: Area2D):
	# Check if hit enemy
	if area.get_parent() in enemy_container.get_children():
		var enemy = area.get_parent()
		var damage = projectile.get_meta("damage")
		damage_enemy(enemy, damage)
		projectile.queue_free()

func handle_enemy_spawning(delta):
	if enemies_remaining <= 0:
		return

	spawn_timer -= delta
	if spawn_timer <= 0:
		spawn_enemy()
		enemies_remaining -= 1
		spawn_timer = spawn_interval

func spawn_enemy():
	if not enemy_scene:
		return

	var enemy = enemy_scene.instantiate()

	# Spawn at random position at top
	var spawn_x = randf_range(100, 1820)
	enemy.position = Vector2(spawn_x, -50)

	enemy_container.add_child(enemy)

func damage_enemy(enemy: Node2D, damage: int):
	var health = enemy.get_meta("health", 30)
	health -= damage

	if health <= 0:
		enemy.queue_free()
		enemies_defeated += 1
	else:
		enemy.set_meta("health", health)

func _on_player_hit(area: Area2D):
	# Hit by enemy or enemy projectile
	if area.get_parent() in enemy_container.get_children():
		player_health -= 10
		update_ui()

func check_game_state():
	# Win condition: all enemies defeated
	if enemies_remaining <= 0 and enemy_container.get_child_count() == 0:
		win_game()

	# Loss condition: health depleted
	if player_health <= 0:
		lose_game()

func win_game():
	game_manager.complete_dungeon_run(true)
	# Return to hub (game manager handles this)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func lose_game():
	game_manager.complete_dungeon_run(false)
	# Return to hub or game over
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func update_ui():
	$UI/HealthLabel.text = "Health: %d" % player_health
	$UI/EnemiesLabel.text = "Enemies: %d" % (enemies_remaining + enemy_container.get_child_count())
	$UI/WaveLabel.text = "Wave: %d" % current_wave
