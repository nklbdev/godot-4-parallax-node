@tool
extends EditorPlugin

const __class_name: String = "Parallax"
const __base_class_name: String = "Node2D"
const __script: GDScript = preload("Parallax.gd")
const __icon_texture: Texture2D = preload("type_icon.svg")

func _enter_tree():
	add_custom_type(__class_name, __base_class_name, __script, __icon_texture)

func _exit_tree():
	remove_custom_type(__class_name)
