extends CanvasLayer

@onready var fruit_label = $HBoxContainer/Label
@onready var fruit_icon = $HBoxContainer/TextureRect

func _ready() -> void:
	GameManager.fruit_count_changed.connect(_on_fruit_count_changed)
	update_ui(GameManager.current_fruits)
	
func _on_fruit_count_changed(new_count: int) -> void:
	update_ui(new_count)
	play_pulse_animation()

func update_ui(count: int) -> void: 
	fruit_label.text = str(count)

func play_pulse_animation() -> void: 
	var tween = create_tween()
	tween.tween_property(fruit_label, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_SINE)
	tween.tween_property(fruit_label, "scale", Vector2(1.0, 1.0), 0.1).set_trans(Tween.TRANS_SINE)
