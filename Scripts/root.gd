extends Node2D

signal add_field

var fields = Array([], TYPE_OBJECT, "Node2D", null)


func _ready() -> void:
	pass


func create_field(is_scalar: bool) -> Node:
	var field: Node
	if is_scalar:
		field = load(Globals.scenes_path + "scalar_field.tscn").instantiate()
	else:
		field = load(Globals.scenes_path + "vector_field.tscn").instantiate()
	fields.append(field)
	add_child(field)
	add_field.emit(is_scalar)
	return field


func _on_create_scalar_field_pressed() -> void:
	create_field(true)


func _on_create_vector_field_pressed() -> void:
	create_field(false)


func _on_calculate_field(id: int, type: int) -> void:
	if type == 0:
		var vector_field: Node = create_field(false)
		vector_field.find_gradient(fields[id].data)


func _on_delete_field(id: int) -> void:
	var field: Node = fields.pop_at(id)
	field.queue_free()


func _on_select_field(id: int, toggled_on: bool) -> void:
	if toggled_on:
		for i in range(fields.size()):
			fields[i].selected = false
	fields[id].selected = toggled_on


func _on_view_field(id: int, toggled_on: bool) -> void:
	fields[id].visible = toggled_on
