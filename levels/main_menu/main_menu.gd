extends Control

@onready var start_button = $CenterContainer/VBoxContainer/PlayButton
@onready var level_name_label = $CenterContainer/VBoxContainer/LevelNameLabel # Optional: "Next: Dungeon"

func _ready():
	# Ensure the game isn't paused if coming back from a win screen
	Engine.time_scale = 1.0
	
	# Get the first level's data to display on the menu
	if LevelManager.levels.size() > 0:
		var first_level = LevelManager.levels[0]
		level_name_label.text = "Starting: " + first_level.level_name
	
	# Focus the start button for controller support (like Marvel Rivals!)
	start_button.grab_focus()

func _on_play_button_pressed():
	# Reset the index to 0 just in case
	LevelManager.current_level_index = 0
	# Tell the manager to load the first level in its array
	var first_level = LevelManager.levels[0]
	get_tree().change_scene_to_packed(first_level.level_scene)

func _on_quit_button_pressed():
	get_tree().quit()
