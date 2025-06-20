extends PanelContainer

signal calculate_field
signal delete_field
signal select_field
signal view_field

var id: int
var is_scalar_field: bool = false
var is_not_visible: bool = true


func update_ui():
	if is_scalar_field:
		get_node("HBoxContainer/Label").text = "Scalar Field"
		get_node("HBoxContainer/Gradient").disabled = false
	else:
		get_node("HBoxContainer/Label").text = "Vector Field"
		get_node("HBoxContainer/Divergence").disabled = false
		get_node("HBoxContainer/Curl").disabled = false
	get_node("HBoxContainer/Visible").button_pressed = !is_not_visible


func _on_gradient_pressed() -> void:
	calculate_field.emit(id, 0)


func _on_divergence_pressed() -> void:
	calculate_field.emit(id, 1)


func _on_curl_pressed() -> void:
	calculate_field.emit(id, 2)


func _on_delete_pressed() -> void:
	delete_field.emit(id)


func _on_check_box_toggled(toggled_on: bool) -> void:
	select_field.emit(id, toggled_on)


func _on_visible_toggled(toggled_on: bool) -> void:
	is_not_visible = !toggled_on
	view_field.emit(id, toggled_on)
