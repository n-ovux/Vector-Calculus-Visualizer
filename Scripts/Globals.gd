extends Node2D

# Paths
const scenes_path: String = "res://Scenes/"
const textures_path: String = "res://Textures/"
const shaders_path: String = "res://Scripts/Shaders/"
const root: String = "/root/Root/"
const camera: String = root + "Camera2D"

# Project Settings
var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
var screen_height: int = ProjectSettings.get_setting("display/window/size/viewport_height")
