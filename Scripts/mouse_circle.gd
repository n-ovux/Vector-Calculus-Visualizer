extends Polygon2D

signal drawing

const scale_factor: float = 5
var enabled: bool = true

func generate_polygon() -> void:
	# generate circle vertices
	var vertices: PackedVector2Array = PackedVector2Array()
	var resolution: float = sqrt(scale.x) + 10
	for i in resolution:
		vertices.append(Vector2.UP.rotated(2*PI * (i/resolution)))
	set_polygon(vertices)
	set_uv(vertices)

	# recalculate offset
	texture_offset = (64/(2.0*texture_scale.x))*Vector2.ONE

func _ready() -> void:
	# set size of circle
	scale = Vector2(25, 25)
	generate_polygon()


func _process(delta: float) -> void:
	if !enabled:
		pass
	position = get_viewport().get_mouse_position()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		color = Color(1, 0, 0, 1)
		drawing.emit(true, scale.x, position, delta)
	elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		color = Color(0.593, 0.142, 0.817, 1)
		drawing.emit(false, scale.x, position, delta)
	else:
		color = Color(1, 1, 1, 1)

func _input(event: InputEvent) -> void:
	if !enabled:
		pass
	if event is InputEventMouseButton && event.pressed:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP && scale.x < 100:
			scale += scale_factor * log(scale.x) * Vector2.ONE
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			scale -= scale_factor * log(scale.x) * Vector2.ONE

		if scale.length_squared() < 200:
			scale = Vector2(10, 10)

		generate_polygon()

