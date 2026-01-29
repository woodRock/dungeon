extends Area3D

@export var fruit_value = 1
@export var rotation_speed: float = 2.0 
@export var bob_height: float = 0.2 
@export var bob_speed: float = 3.0

@onready var mesh = $MeshInstance3D
var time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	# Make it spin. 
	rotate_y(rotation_speed * delta)
	# Make it float up and down.
	mesh.position.y = sin(time * bob_speed) * bob_height

func _on_body_entered(body: Node3D) -> void:
	
	if body is CharacterBody3D:
		collect()
		
func collect() -> void: 
	# Stop the fruit from being collected twice.
	monitoring = false 
	
	# Update global fruit count.
	GameManager.add_fruit(fruit_value)
	
	# Create a pop animation
	var tween = create_tween().set_parallel(true)
	# Scale it up slightly then to zero 
	tween.tween_property(self, "scale", Vector3.ONE * 1.5, 0.1)
	tween.chain().tween_property(self, "scale", Vector3.ZERO, 0.2)
	# Fade out if you have a material set up.
	
	# Wait for the animation to finish before deleting. 
	await tween.finished 
	queue_free()
