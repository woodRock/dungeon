extends Node3D

@onready var door = $wall_doorway/wall_doorway/wall_doorway_door
@export var open_angle: float = 90.0
@export var open_speed: float = 1.2

var is_open: bool = false 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_area_3d_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D and not is_open:
		open_door() 
		
func open_door() -> void: 
	is_open = true 
	var tween: Tween = create_tween() 
	tween.tween_property(door, "rotation:y", deg_to_rad(open_angle), open_speed).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	_win_sequence()

# Inside your doorway script (Area3D)
func _win_sequence():
	# Find the UI in the scene
	var victory_ui = get_tree().root.find_child("VictoryUI", true, false)
	var fruit_count = GameManager.current_fruits

	if victory_ui:
		# Pass in the player's fruit count (if you have one)
		# For now, we'll just send 0
		victory_ui.show_ui(fruit_count)
		
	# Pause the rest of the game logic if needed
	#get_tree().paused = true
