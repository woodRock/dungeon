extends Camera3D

# Leave this empty in code; we will set it in the Editor
@export var player_path: NodePath
var target: Node3D

func _ready() -> void:
	if player_path:
		# Use 'as CharacterBody3D' to cast the type correctly
		target = get_node(player_path) as Node3D
		
		# Optional: Add a check to make sure it worked
		if target == null:
			print("Error: The node at player_path is not a CharacterBody3D!")
			
func _process(_delta: float) -> void:
	if target:
		# 1. Update positions
		global_position.z = target.global_position.z + 6 
		global_position.x = lerp(global_position.x, target.global_position.x, 0.1)
		global_position.y = target.global_position.y + 4

		# 2. Look at the player
		look_at(target.global_position)
