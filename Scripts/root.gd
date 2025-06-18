extends Node2D

signal created_scalar_field

func _ready() -> void:
	pass

func _on_button_pressed() -> void:
	var scalar_field = get_node_or_null("Scalar Field")
	if scalar_field != null:
		scalar_field.queue_free()
		await scalar_field.tree_exited
	add_child(load("res://Scenes/scalar_field.tscn").instantiate())
	created_scalar_field.emit()

func _on_find_gradient_pressed() -> void:
	var gradient_field = get_node_or_null("Gradient Field")
	if gradient_field != null:
		gradient_field.queue_free()
		await gradient_field.tree_exited
	add_child(load("res://Scenes/gradient_field.tscn").instantiate())
