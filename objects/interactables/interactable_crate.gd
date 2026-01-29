extends StaticBody3D

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
	# Shared logic for destroying the barrel
	queue_free()
