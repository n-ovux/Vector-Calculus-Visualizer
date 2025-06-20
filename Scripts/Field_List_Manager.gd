extends VBoxContainer

signal calculate_field
signal delete_field
signal select_field
signal view_field

var fields = Array([], TYPE_OBJECT, "PanelContainer", null)


func _on_root_add_field(is_scalar: bool) -> void:
	var item: PanelContainer = load(Globals.scenes_path + "field_item.tscn").instantiate()
	item.custom_minimum_size.y = 45
	if is_scalar:
		item.is_scalar_field = true
		item.update_ui()
	else:
		item.is_scalar_field = false
		item.update_ui()
	item.id = fields.size()
	item.calculate_field.connect(_on_calculate_field)
	item.delete_field.connect(_on_delete_field)
	item.select_field.connect(_on_select_field)
	item.view_field.connect(_on_view_field)
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


func _on_select_field(id: int, toggled_on: bool):
	if toggled_on:
		for i in range(fields.size()):
			if i != id:
				fields[i].get_node("HBoxContainer/Selected").button_pressed = false
	select_field.emit(id, toggled_on)


func _on_view_field(id: int, toggled_on: bool):
	if toggled_on:
		for i in range(fields.size()):
			var enabled: bool = (
				(i == id)
				|| (
					(
						(fields[i].is_scalar_field && !fields[id].is_scalar_field)
						|| (!fields[i].is_scalar_field && fields[id].is_scalar_field)
					)
					&& !fields[i].is_not_visible
				)
			)
			fields[i].is_not_visible = !enabled
			fields[i].update_ui()
			view_field.emit(i, enabled)
	else:
		fields[id].is_not_visible = true
		view_field.emit(id, false)
