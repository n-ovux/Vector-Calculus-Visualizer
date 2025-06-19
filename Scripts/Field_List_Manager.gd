extends VBoxContainer

var fields = Array([], TYPE_OBJECT, "PanelContainer", null)


func _on_root_add_field(is_scalar: bool) -> void:
	var item: PanelContainer = load(Paths.scenes_path + "field_item.tscn").instantiate()
	item.custom_minimum_size.y = 45
	if is_scalar:
		item.get_node("HBoxContainer/Gradient").disabled = false
	else:
		item.get_node("HBoxContainer/Divergence").disabled = false
		item.get_node("HBoxContainer/Curl").disabled = false
	fields.append(item)
	add_child(item)
