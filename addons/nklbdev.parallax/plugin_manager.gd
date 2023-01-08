@tool
extends EditorPlugin

const __class_name: String = "Parallax"
const __base_class_name: String = "Node2D"
const __script: GDScript = preload("Parallax.gd")
const __icon_texture: Texture2D = preload("type_icon.svg")

func _enter_tree():
	add_custom_type(__class_name, __base_class_name, __script, __resize_texture(__icon_texture, get_editor_interface().get_editor_scale() / 4))

func _exit_tree():
	remove_custom_type(__class_name)

static func __resize_texture(texture: Texture2D, scale: float) -> Texture2D:
	var image: Image = texture.get_image() as Image
	var new_size: Vector2i = Vector2i((image.get_size() * scale).round())
	image.resize(new_size.x, new_size.y)
	var new_texture: ImageTexture = ImageTexture.create_from_image(image)
	return new_texture
