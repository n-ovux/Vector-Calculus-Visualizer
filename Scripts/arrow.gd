extends Line2D

var length: float = 1.0


func resample():
	var end_point: Vector2 = length * Vector2.RIGHT
	var arrow_head: Vector2 = Vector2(
		sqrt(end_point.length()) * 0.8, sqrt(end_point.length() * 0.6)
	)

	clear_points()
	add_point(Vector2.ZERO, 0)
	add_point(end_point, 1)
	add_point(end_point - arrow_head, 2)
	add_point(end_point, 3)
	add_point(end_point - arrow_head.reflect(Vector2.RIGHT), 4)


func _ready() -> void:
	width = 1
	default_color = Color(0, 0, 0, 1)
	resample()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.keycode == KEY_E && event.pressed:
			resample()
