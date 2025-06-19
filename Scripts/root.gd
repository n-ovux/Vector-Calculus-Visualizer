extends Node2D

signal add_field

var fields = Array([], TYPE_OBJECT, "Node2D", null)


func _ready() -> void:
	pass


func _on_create_scalar_field_pressed() -> void:
	var scalar_field: Node2D = get_node_or_null("Scalar Field")
	if scalar_field != null:
		scalar_field.queue_free()
		await scalar_field.tree_exited
	scalar_field = load(Paths.scenes_path + "scalar_field.tscn").instantiate()
	fields.append(scalar_field)
	add_child(scalar_field)
	add_field.emit(true)


func _on_create_vector_field_pressed() -> void:
	var gradient_field = get_node_or_null("Gradient Field")
	if gradient_field != null:
		gradient_field.queue_free()
		await gradient_field.tree_exited
	gradient_field = load(Paths.scenes_path + "vector_field.tscn").instantiate()
	fields.append(gradient_field)
	add_child(gradient_field)
