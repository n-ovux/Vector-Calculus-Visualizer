extends Camera2D

var dragging: bool = false


func _ready() -> void:
	position = Vector2(Globals.screen_width / 2.0, Globals.screen_height / 2.0)
	limit_top = 0
	limit_bottom = Globals.screen_height
	limit_left = 0
	limit_right = Globals.screen_width


func _process(delta: float) -> void:
	check_bounds()
	pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
		if !event.pressed || !event.ctrl_pressed:
			return
		match event.button_index:
			MOUSE_BUTTON_WHEEL_UP:
				zoom_camera(true)
			MOUSE_BUTTON_WHEEL_DOWN:
				zoom_camera(false)
	elif event is InputEventMouseMotion:
		if dragging:
			position -= event.relative
	elif event is InputEventKey:
		if !event.pressed:
			return
		if event.keycode == KEY_0:
			zoom = Vector2.ONE
			position = Vector2(Globals.screen_width / 2.0, Globals.screen_height / 2.0)


func zoom_camera(zoom_in: bool):
	if zoom_in:
		zoom = clamp(zoom + 0.5 * Vector2.ONE, Vector2.ONE, 5 * Vector2.ONE)
	else:
		zoom = clamp(zoom - 0.5 * Vector2.ONE, Vector2.ONE, 5 * Vector2.ONE)


func check_bounds():
	if position != get_screen_center_position():
		position = get_screen_center_position()
