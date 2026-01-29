extends Node

# Drag your .tres resource files into this array in the Inspector
@export var levels: Array[LevelData] = [
	preload("res://resources/levels/level_01.tres"),
	preload("res://resources/levels/level_02.tres"),
	preload("res://resources/levels/level_03.tres")
]

var current_level_index: int = 0

func get_current_level() -> LevelData:
	return levels[current_level_index]

func load_next_level():
	current_level_index += 1
	
	if current_level_index < levels.size():
		var next_level = levels[current_level_index]
		# Reset fruits for the new level
		GameManager.reset_fruits() 
		get_tree().change_scene_to_packed(next_level.level_scene)
	else:
		# No more levels? Send them to the credits or main menu
		print("Game Complete!")
		get_tree().change_scene_to_file("res://scenes/menus/main_menu.tscn")

func restart_level():
	GameManager.reset_fruits()
	get_tree().reload_current_scene()
