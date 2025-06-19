extends PanelContainer

signal calculate_field
signal delete_field

var id: int


func _on_gradient_pressed() -> void:
	calculate_field.emit(id, 0)


func _on_divergence_pressed() -> void:
	calculate_field.emit(id, 1)


func _on_curl_pressed() -> void:
	calculate_field.emit(id, 2)


func _on_delete_pressed() -> void:
	delete_field.emit(id)
