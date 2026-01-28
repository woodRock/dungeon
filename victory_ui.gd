extends CanvasLayer

# --- Nodes ---
@onready var color_rect = $ColorRect
@onready var title_label = $ColorRect/CenterContainer/VBoxContainer/TitleLabel
@onready var stats_label = $ColorRect/CenterContainer/VBoxContainer/StatsLabel
@onready var next_button = $ColorRect/CenterContainer/VBoxContainer/NextLevelButton
@onready var menu_button = $ColorRect/CenterContainer/VBoxContainer/MainMenuButton

# --- Configuration ---
@export var next_level_path: String = ""
@export var menu_scene_path: String = "res://main_menu.tscn"

func _ready():
	self.hide()
	color_rect.modulate.a = 0
	
	next_button.pressed.connect(_on_next_level_button_pressed)
	menu_button.pressed.connect(_on_main_menu_button_pressed)

func show_ui(fruit_count: int):
	stats_label.text = "Fruits Collected: " + str(fruit_count)
	self.show()
	
	# Fade background
	var fade_tween = create_tween().set_parallel(true)
	fade_tween.tween_property(color_rect, "modulate:a", 1.0, 0.5)
	
	# Bounce title (Using Vector2 for UI!)
	title_label.pivot_offset = title_label.size / 2
	title_label.scale = Vector2.ZERO
	
	var pop_tween = create_tween()
	pop_tween.tween_property(title_label, "scale", Vector2(1.2, 1.2), 0.3)\
		.set_trans(Tween.TRANS_BACK)\
		.set_ease(Tween.EASE_OUT)
	pop_tween.tween_property(title_label, "scale", Vector2(1.0, 1.0), 0.1)
	
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_next_level_button_pressed() -> void:
	if next_level_path == "":
		get_tree().reload_current_scene()
	else:
		get_tree().change_scene_to_file(next_level_path)

func _on_main_menu_button_pressed() -> void:
	if FileAccess.file_exists(menu_scene_path):
		get_tree().change_scene_to_file(menu_scene_path)
	else:
		get_tree().reload_current_scene()
