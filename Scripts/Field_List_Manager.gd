extends VBoxContainer

signal calculate_field
signal delete_field

var fields = Array([], TYPE_OBJECT, "PanelContainer", null)


func _on_root_add_field(is_scalar: bool) -> void:
	var item: PanelContainer = load(Paths.scenes_path + "field_item.tscn").instantiate()
	item.custom_minimum_size.y = 45
	if is_scalar:
		item.get_node("HBoxContainer/Gradient").disabled = false
	else:
		item.get_node("HBoxContainer/Divergence").disabled = false
		item.get_node("HBoxContainer/Curl").disabled = false
	item.id = fields.size()
	item.calculate_field.connect(_on_calculate_field)
	item.delete_field.connect(_on_delete_field)
	fields.append(item)
	add_child(item)


func _on_calculate_field(id: int, type: int):
	calculate_field.emit(id, type)


func _on_delete_field(id: int):
	delete_field.emit(id)
	var field: PanelContainer = fields.pop_at(id)
	field.queue_free()
	for item_id in range(id, fields.size()):
		fields[item_id].id -= 1
