extends CharacterBody3D

## --- Configuration ---
@export_group("Movement")
@export var SPEED: float = 7.0
@export var JUMP_VELOCITY: float = 6.0
@export var ROTATION_SPEED: float = 12.0

@export_group("Abilities")
@export var spin_duration: float = 0.3 # Shortened for snappiness
@export var coyote_duration: float = 0.15 

# --- Nodes ---
@onready var anim_player: AnimationPlayer = $ModelContainer/Knight/AnimationPlayer
@onready var mesh: Node3D = $ModelContainer
@onready var spin_area: Area3D = $SpinArea
@onready var feet_ray: RayCast3D = $RayCast3D

# --- Variables ---
var is_spinning: bool = false
var coyote_timer: float = 0.0
var is_dead = false 

func _physics_process(delta: float) -> void:
	# IF DEAD: Stop all logic and don't process movement/animations
	if is_dead:
		return
		
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if is_on_floor():
		coyote_timer = coyote_duration
	else:
		coyote_timer -= delta

	# Jump
	if Input.is_action_just_pressed("ui_accept") and coyote_timer > 0:
		velocity.y = JUMP_VELOCITY
		coyote_timer = 0.0 
		_play_animation("Movement/Jump_Full_Short")

	# Movement
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := Vector3(input_dir.x, 0, input_dir.y).normalized()
	
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		var target_angle = atan2(-direction.x, -direction.z)
		mesh.rotation.y = lerp_angle(mesh.rotation.y, target_angle, ROTATION_SPEED * delta)
		
		if is_on_floor() and not is_spinning and is_equal_approx(velocity.y, 0.0):
			_play_animation("Movement/Walking_A")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
		if is_on_floor() and not is_spinning and is_equal_approx(velocity.y, 0.0):
			_play_animation("General/Idle_A")

	if not is_on_floor() and velocity.y < 0:
		_check_for_squash()

	move_and_slide()
	
	if Input.is_action_just_pressed("spin") and not is_spinning:
		start_spin()

func _check_for_squash():
	if feet_ray.is_colliding():
		var target = feet_ray.get_collider()
		if target and target.has_method("squash"):
			target.squash()
			velocity.y = JUMP_VELOCITY 
			_play_animation("Movement/Jump_Full_Short")

func start_spin() -> void: 
	is_spinning = true
	spin_area.monitoring = true 
	
	# Increase animation speed for the spin specifically
	# We use the 'Hit_A' or 'Attack' animation at 1.5x speed
	anim_player.play("General/Hit_A", -1, 2.0) 
	
	# A tiny bit of manual rotation can still help 'sell' the spin
	var tween = create_tween()
	tween.tween_property(mesh, "rotation:y", mesh.rotation.y + TAU, spin_duration)
	
	# Detect hits
	var overlapping = spin_area.get_overlapping_bodies()
	for body in overlapping: 
		if body.has_method("die"):
			body.die()
	
	await get_tree().create_timer(spin_duration).timeout 
	stop_spin() 

func stop_spin() -> void:
	is_spinning = false 
	spin_area.monitoring = false
	
func die() -> void: 
	# Can only die once.
	if is_dead: 
		return
		
	# The player is dead.
	is_dead = true
	
	# Stop all movement.
	velocity = Vector3.ZERO
	
	# Play the death animation.
	_play_animation("General/Death_A")
	
	# Wait for death animation to finish.
	var death_length = anim_player.get_animation("General/Death_A").length
	await get_tree().create_timer(death_length).timeout
	
	# Restart the level.
	LevelManager.restart_level()
	 
func _play_animation(anim_name: String) -> void:
	if not anim_player or not anim_player.has_animation(anim_name):
		return
	if anim_player.current_animation != anim_name:
		# Reset playback speed to normal for non-spin animations
		anim_player.play(anim_name, -1, 1.0)
