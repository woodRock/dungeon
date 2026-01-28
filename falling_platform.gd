extends AnimatableBody3D

@export var fall_delay: float = 1.0     # How long before it falls
@export var respawn_time: float = 3.0  # How long before it reappears
@export var shake_intensity: float = 0.05

@onready var timer: Timer = $Timer
@onready var collision: CollisionShape3D = $CollisionShape3D
@onready var initial_pos: Vector3 = position

var is_falling: bool = false

func _ready():
	# Connect the Area3D signal to detect the player
	$Area3D.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_start_fall)

func _on_body_entered(body):
	# Only trigger if it's the player and not already falling
	if body is CharacterBody3D and not is_falling:
		trigger_shake()

func trigger_shake():
	is_falling = true
	
	# Create a "shaking" effect using a Tween
	var tween = create_tween()
	for i in range(10):
		var random_offset = Vector3(randf_range(-shake_intensity, shake_intensity), 0, randf_range(-shake_intensity, shake_intensity))
		tween.tween_property(self, "position", initial_pos + random_offset, 0.05)
	
	# Start the countdown to the fall
	timer.start(fall_delay)

func _start_fall():
	# Drop the platform out of the world
	var fall_tween = create_tween()
	fall_tween.tween_property(self, "position", initial_pos + Vector3(0, -20, 0), 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	
	# Disable collision so the player falls through the gap
	collision.disabled = true
	
	# Wait for respawn
	await get_tree().create_timer(respawn_time).timeout
	respawn_platform()

func respawn_platform():
	# Reset everything
	position = initial_pos
	collision.disabled = false
	is_falling = false
	# Optional: add a "fade in" effect here!
