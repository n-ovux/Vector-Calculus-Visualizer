extends Node2D

var data: Image
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var amount: Vector2i = Vector2i(10, 10)

func _ready() -> void:
	position = Vector2.ZERO

	data = Image.create_empty(screen_width, screen_height, false, Image.FORMAT_RGF)
	data.fill(Color.BLACK)

	var arrows: Array = Array([], TYPE_OBJECT, "Sprite2D", null)
	arrows.resize(amount.x * amount.y)

	for x in amount.x:
		for y in amount.y:
			var index: int = y + amount.y * x
			arrows[index] = Sprite2D.new()
			arrows[index].texture = load("res://Texture Resources/arrow.svg")
			arrows[index].scale = 0.02*Vector2.ONE
			arrows[index].position = Vector2(screen_width*(float(x)/amount.x), screen_height*(float(y)/amount.y)) + Vector2(screen_width/(2.0*amount.x), screen_height/(2.0*amount.y))
			add_child(arrows[index])
