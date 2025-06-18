extends Sprite2D

var data: Image
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")

@export var draw_speed: float = 3

func circle(location: Vector2, radius: float, color: Color) -> void:
	for x in range(clamp(location.x - radius, 0, screen_width), clamp(location.x + radius, 0, screen_width)):
		for y in range(clamp(location.y - radius, 0, screen_height), clamp(location.y + radius, 0, screen_height)):
			var distance: float = sqrt(pow(x - location.x, 2) + pow(y - location.y, 2))
			var value: float = lerpf(color.r, 0, ease(clamp(distance/radius, 0, 1), -1.6))
			value += data.get_pixel(x, y).r
			value = clamp(value, 0, 1)
			data.set_pixel(x, y, Color(value, 0, 0, 0))

func _ready() -> void:
	position = Vector2(screen_width/2.0, screen_height/2.0)

	data = Image.create_empty(screen_width, screen_height, false, Image.FORMAT_RF)
	data.fill(Color(0.5, 0, 0, 0))

	texture = ImageTexture.create_from_image(data)

	var mouse = get_node("../UI/Mouse")
	mouse.drawing.connect(_on_draw)

func _on_draw(adding: bool, size: float, location: Vector2, delta_time: float) -> void:
	if adding:
		circle(location, size, Color(draw_speed*delta_time, 0, 0, 0))
	else:
		circle(location, size, Color(-draw_speed*delta_time, 0, 0, 0))

	texture.update(data)
