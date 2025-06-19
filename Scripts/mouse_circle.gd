extends Polygon2D

signal drawing

const scale_factor: float = 5
enum State { ADDING, SUBTRACTING, NONE }
var state: State = State.NONE


func generate_polygon() -> void:
	# generate circle vertices
	var vertices: PackedVector2Array = PackedVector2Array()
	var resolution: float = sqrt(scale.x) + 10
	for i in resolution:
		vertices.append(Vector2.UP.rotated(2 * PI * (i / resolution)))
	set_polygon(vertices)
	set_uv(vertices)

	# recalculate offset
	texture_offset = (64 / (2.0 * texture_scale.x)) * Vector2.ONE


func _ready() -> void:
	scale = Vector2(25, 25)
	generate_polygon()


func _process(delta: float) -> void:
	match state:
		State.ADDING:
			drawing.emit(true, scale.x, position, delta)
		State.SUBTRACTING:
			drawing.emit(false, scale.x, position, delta)
		State.NONE:
			pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if (
			event.button_index == MOUSE_BUTTON_WHEEL_UP
			|| event.button_index == MOUSE_BUTTON_WHEEL_DOWN && event.pressed
		):
			if event.button_index == MOUSE_BUTTON_WHEEL_UP && scale.x < 100:
				scale += scale_factor * log(scale.x) * Vector2.ONE
			else:
				scale -= scale_factor * log(scale.x) * Vector2.ONE

			if scale.length_squared() < 200:
				scale = Vector2(10, 10)

		elif event.button_index == MOUSE_BUTTON_LEFT && event.pressed:
			color = Color(1, 0, 0, 1)
			state = State.ADDING
		elif event.button_index == MOUSE_BUTTON_RIGHT && event.pressed:
			color = Color(0.593, 0.142, 0.817, 1)
			state = State.SUBTRACTING
		else:
			color = Color(1, 1, 1, 1)
			state = State.NONE

		generate_polygon()
	elif event is InputEventMouseMotion:
		position = event.position
