extends Node3D

@export var initial_delay: float = 0.0 # New: Wait before starting the cycle
@export var cycle_time: float = 2.0  
@export var extend_distance: float = 2.0
@export var transition_speed: float = 0.2

@onready var spikes: MeshInstance3D = $floor_tile_big_spikes/floor_tile_big_spikes/spikes
@onready var timer = $Timer
@onready var area_3d = $Area3D

var is_out: bool = false

func _ready():
	# 1. Prepare initial state (hidden)
	spikes.position.y = -extend_distance
	area_3d.monitoring = false
	
	# 2. Wait for the custom delay before starting the timer
	if initial_delay > 0:
		await get_tree().create_timer(initial_delay).timeout
	
	# 3. Start the repeating cycle
	timer.wait_time = cycle_time
	timer.timeout.connect(_on_timer_timeout)
	timer.start()

func _on_timer_timeout():
	is_out = !is_out
	var tween = create_tween().set_parallel(true)
	
	# Local target positions
	var hidden_y = -extend_distance
	var visible_y = 0.0 

	if is_out:
		# Pop UP
		tween.tween_property(spikes, "position:y", visible_y, transition_speed)\
			.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
		
		# Enable kill zone mid-animation
		await get_tree().create_timer(transition_speed / 2.0).timeout
		if is_out: # Safety check in case it retracted quickly
			area_3d.monitoring = true
	else:
		# Go DOWN
		tween.tween_property(spikes, "position:y", hidden_y, transition_speed)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN)
		area_3d.monitoring = false

func _on_area_3d_body_entered(body):
	if body is CharacterBody3D and not body.is_dead:
		body.die()
		
		var anim_player: AnimationPlayer = body.get_node("ModelContainer/Knight/AnimationPlayer")
		var death_length: float = anim_player.get_animation("General/Death_A").length
		
		await get_tree().create_timer(death_length).timeout
		LevelManager.restart_level()
