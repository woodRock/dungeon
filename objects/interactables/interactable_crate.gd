extends StaticBody3D

@export var fruit_scene: PackedScene 
@export var fruit_count: int = 3 
@export var spawn_radius: float = 1

func die():
	# This is for the spin attack
	_break_barrel()

func squash():
	var tween = create_tween()
	# Scale the barrel down (X/Z expand, Y flattens)
	tween.tween_property(self, "scale", Vector3(1.5, 0.2, 1.5), 0.1)
	# Wait a tiny bit then delete
	await tween.finished
	_break_barrel()

func _break_barrel():
	print("Barrel Breaking!")
	
	# 1. Disable the Barrel's visual and physical presence immediately
	# Adjust these names to match your actual child node names (e.g., $Mesh, $Collision)
	if has_node("MeshInstance3D"): $MeshInstance3D.hide()
	if has_node("CollisionShape3D"): $CollisionShape3D.set_deferred("disabled", true)
	
	# 2. Spawn the fruits
	if fruit_scene:
		print("Spawning ", fruit_count, " fruits")
		for i in range(fruit_count):
			spawn_fruit()
	
	# 3. The Wait: Give the tweens time to finish (0.5s based on your tween code)
	# This keeps the "Owner" of the tweens alive long enough to finish the animation
	await get_tree().create_timer(0.6).timeout
	
	# 4. Finally, delete the barrel
	queue_free()
	
func spawn_fruit() -> void: 
	var fruit = fruit_scene.instantiate()
	get_tree().current_scene.add_child(fruit)
	
	fruit.global_position = global_position 
	# Start at zero so they "pop" into existence
	fruit.scale = Vector3.ONE
	
	# Calculate a unique landing spot for EACH fruit
	var target_position = global_position + Vector3(
		randf_range(-spawn_radius, spawn_radius),
		0,
		randf_range(-spawn_radius, spawn_radius)
	)
	
	print("Target_position: ", target_position)

	var tween = create_tween()
	
	# --- The Outward Burst (Parallel) ---
	tween.set_parallel(true)
	tween.tween_property(fruit, "scale", Vector3.ONE, 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(fruit, "global_position:x", target_position.x, 0.5).set_trans(Tween.TRANS_SINE)
	tween.tween_property(fruit, "global_position:z", target_position.z, 0.5).set_trans(Tween.TRANS_SINE)
	
	# --- The Arch (Sequential Y-axis) ---
	# We use a second tween for the Y so it doesn't fight the parallel X/Z
	var y_tween = create_tween()
	y_tween.tween_property(fruit, "global_position:y", global_position.y + 2.0, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	y_tween.tween_property(fruit, "global_position:y", target_position.y, 0.25).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
