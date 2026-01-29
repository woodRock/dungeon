extends Control

@export var first_level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_play_button_pressed() -> void:
	if first_level:
		get_tree().change_scene_to_packed(first_level)
	else:
		print("No first level assigned to main menu!")	
	
func _on_quit_button_pressed() -> void:
	get_tree().quit()
