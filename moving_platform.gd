extends AnimatableBody3D

@export var offset = Vector3(5, 0, 0) # How far to move
@export var duration = 3.0           # How long it takes

func _ready():
	var tween = create_tween().set_loops()
	# Move to the destination
	tween.tween_property(self, "position", position + offset, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
	# Move back to start
	tween.tween_property(self, "position", position, duration)\
		.set_trans(Tween.TRANS_SINE)\
		.set_ease(Tween.EASE_IN_OUT)
