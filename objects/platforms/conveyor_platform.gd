extends StaticBody3D

enum Direction { FORWARD, BACKWARD, LEFT, RIGHT }

@export var speed: float = 4.0
@export var movement_direction: Direction = Direction.BACKWARD # Default to "Towards Player"

@onready var mesh = $MeshInstance3D

func _ready():
	update_conveyor()

func update_conveyor():
	var velocity_vector = Vector3.ZERO
	var visual_axis = Vector2.ZERO # Which axis to scroll on
	
	match movement_direction:
		Direction.FORWARD:
			velocity_vector = Vector3(0, 0, -speed)
			visual_axis = Vector2(0, 1) # Scroll on V (Z-axis)
		Direction.BACKWARD:
			velocity_vector = Vector3(0, 0, speed)
			visual_axis = Vector2(0, 1) # Still scroll on V, but speed will flip it
		Direction.LEFT:
			velocity_vector = Vector3(-speed, 0, 0)
			visual_axis = Vector2(1, 0) # Scroll on U (X-axis)
		Direction.RIGHT:
			velocity_vector = Vector3(speed, 0, 0)
			visual_axis = Vector2(1, 0) # Still scroll on U, but speed will flip it

	# Apply to Physics
	constant_linear_velocity = velocity_vector
	
	# Apply to Shader
	var mat = mesh.get_active_material(0)
	if mat is ShaderMaterial:
		# Use velocity_vector's actual signed value to determine visual direction
		# If moving FORWARD (negative Z), the texture will move one way.
		# If moving BACKWARD (positive Z), the texture will move the other.
		var actual_speed = velocity_vector.length()
		if velocity_vector.x < 0 or velocity_vector.z < 0:
			actual_speed *= -1
			
		mat.set_shader_parameter("scroll_speed", actual_speed * 0.2)
		mat.set_shader_parameter("scroll_direction", visual_axis)
