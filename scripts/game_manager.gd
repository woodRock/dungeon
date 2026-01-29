extends Node

# Signal that other nodes (like the HUD) can listen to.
signal fruit_count_changed(new_count)

var current_fruits: int = 0

func add_fruit(amount: int) -> void:
	current_fruits += amount 
	# Emit the signal whenever the value changes. 
	fruit_count_changed.emit(current_fruits)
	print("Total fruits: ", current_fruits)
	
func reset_fruits() -> void: 
	current_fruits = 0
	fruit_count_changed.emit(current_fruits)
