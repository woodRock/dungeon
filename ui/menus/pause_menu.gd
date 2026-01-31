extends Control

func _ready():
	hide() # Start hidden

func _input(event):
	if event.is_action_pressed("ui_cancel"): # Usually the "Esc" key
		toggle_pause()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	visible = new_pause_state
	
	if new_pause_state:
		# Mouse mode to visible so you can click buttons
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		$VBoxContainer/ResumeButton.grab_focus()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED # Or HIDDEN

func _on_resume_button_pressed():
	toggle_pause()

func _on_restart_button_pressed():
	toggle_pause() # Unpause first!
	LevelManager.restart_level()

func _on_quit_button_pressed():
	# CRITICAL: The engine must be unpaused so the next scene can "live"
	get_tree().paused = false 
	
	# Optional: Reset mouse mode so you can actually click the menu
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Change to the main menu scene.
	get_tree().change_scene_to_file("res://ui/menus/main_menu.tscn")
