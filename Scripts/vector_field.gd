extends Node2D

var data: Image
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
var amount: Vector2i = Vector2i(100, 100)
var arrows: Array = Array([], TYPE_OBJECT, "Line2D", null)

var selected: bool = false
var is_scalar_field: bool = true


func set_arrows():
	for x in amount.x:
		for y in amount.y:
			var index: int = y + amount.y * x
			var coordinate: Vector2i = (
				Vector2(screen_width * (float(x) / amount.x), screen_height * (float(y) / amount.y))
				+ Vector2(screen_width / (2.0 * amount.x), screen_height / (2.0 * amount.y))
			)
			var sample: Vector2 = Vector2(
				data.get_pixelv(coordinate).r, data.get_pixelv(coordinate).g
			)
			sample = sample.limit_length(8)
			arrows[index].length = sample.length()
			arrows[index].rotation = sample.angle()
			arrows[index].resample()


func _ready() -> void:
	visible = false

	data = Image.create_empty(screen_width, screen_height, false, Image.FORMAT_RGF)
	data.fill(Color(1.0, 0.0, 0.0, 0.0))

	arrows.resize(amount.x * amount.y)
	for x in amount.x:
		for y in amount.y:
			var index: int = y + amount.y * x
			arrows[index] = Line2D.new()
			arrows[index] = load(Globals.scenes_path + "arrow.tscn").instantiate()
			var coordinate: Vector2i = (
				Vector2(screen_width * (float(x) / amount.x), screen_height * (float(y) / amount.y))
				+ Vector2(screen_width / (2.0 * amount.x), screen_height / (2.0 * amount.y))
			)
			arrows[index].position = coordinate
			add_child(arrows[index])
	set_arrows()

	var mouse = get_node(Globals.root + "UI/Mouse")
	mouse.drawing.connect(_on_draw)


func find_gradient(scalar_field: Image):
	var rd := RenderingServer.create_local_rendering_device()

	var shader_file: Resource = load(Globals.shaders_path + "gradient.glsl")
	var shader_sprirv: RDShaderSPIRV = shader_file.get_spirv()
	var shader: RID = rd.shader_create_from_spirv(shader_sprirv)
	var pipeline: RID = rd.compute_pipeline_create(shader)

	var output_format: RDTextureFormat = RDTextureFormat.new()
	output_format.width = screen_width
	output_format.height = screen_height
	output_format.depth = 1
	output_format.format = RenderingDevice.DATA_FORMAT_R32G32_SFLOAT
	output_format.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
		| RenderingDevice.TEXTURE_USAGE_STORAGE_BIT
		| RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT
	)
	output_format.mipmaps = 1
	var output_id: RID = rd.texture_create(output_format, RDTextureView.new(), [])

	var output_uniform: RDUniform = RDUniform.new()
	output_uniform.binding = 1
	output_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	output_uniform.add_id(output_id)

	var input_format: RDTextureFormat = RDTextureFormat.new()
	input_format.width = screen_width
	input_format.height = screen_height
	input_format.depth = 1
	input_format.format = RenderingDevice.DATA_FORMAT_R32_SFLOAT
	input_format.usage_bits = (
		RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
		| RenderingDevice.TEXTURE_USAGE_STORAGE_BIT
		| RenderingDevice.TEXTURE_USAGE_CAN_COPY_TO_BIT
	)
	input_format.mipmaps = 1
	var input_data: PackedByteArray = scalar_field.get_data()
	var input_id: RID = rd.texture_create(input_format, RDTextureView.new(), [input_data])

	var input_uniform: RDUniform = RDUniform.new()
	input_uniform.binding = 0
	input_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	input_uniform.add_id(input_id)

	var uniform_set: RID = rd.uniform_set_create([input_uniform, output_uniform], shader, 0)

	var compute_list: int = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, screen_width, screen_height, 1)
	rd.compute_list_end()
	rd.submit()
	rd.sync()

	data = Image.create_from_data(
		screen_width, screen_height, false, Image.FORMAT_RGF, rd.texture_get_data(output_id, 0)
	)

	set_arrows()


func _on_draw(adding: bool, size: float, location: Vector2, delta_time: float) -> void:
	if !selected:
		return
	var mouse_speed: Vector2 = Input.get_last_mouse_velocity()
	for x in range(
		clamp(location.x - size, 0, screen_width), clamp(location.x + size, 0, screen_width)
	):
		for y in range(
			clamp(location.y - size, 0, screen_height), clamp(location.y + size, 0, screen_height)
		):
			var distance: float = sqrt(pow(x - location.x, 2) + pow(y - location.y, 2))
			var factor: float = lerpf(1, 0, ease(clamp(distance / size, 0, 1), -1.6))
			var value: Vector2 = factor * mouse_speed
			var current_value: Color = data.get_pixel(x, y)
			value += Vector2(current_value.r, current_value.g)
			value.clamp(Vector2.ZERO, Vector2.ONE)
			data.set_pixel(x, y, Color(value.x, value.y, 0, 0))
	set_arrows()
