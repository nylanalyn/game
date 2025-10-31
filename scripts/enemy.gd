extends Node2D

var health: int = 30
var speed: float = 100.0
var target_position: Vector2

func _ready():
	# Set initial health
	set_meta("health", health)

	# Target is the player position (bottom of screen)
	target_position = Vector2(960, 900)

func _process(delta):
	# Move toward player
	var direction = (target_position - position).normalized()
	position += direction * speed * delta

	# Check if reached bottom (escaped)
	if position.y > 1100:
		queue_free()  # Escaped without being killed
