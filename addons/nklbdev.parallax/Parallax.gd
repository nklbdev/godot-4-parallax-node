@tool @icon("type_icon.svg")
extends Node2D

const __max_arrow_size: float = 6.0
const __line_width: float = 1.4
const __arrow_points: Array = [Vector2.ZERO, Vector2(-1, 0.5), Vector2(-1, -0.5)]
var __draw_color: Color
var __draw_enabled_color: Color
var __draw_disabled_color: Color
@onready var __is_editor: bool = Engine.is_editor_hint()
@onready var __packed_arrow_points: PackedVector2Array = PackedVector2Array(__arrow_points)

enum ProcessMode {
	PROCESS = 0,
	PHYSICS_PROCESS = 1
}

@export var enabled: bool = true : set = __set_enabled
func __set_enabled(value: bool):
	if enabled == value:
		return
	enabled = value
	__update_position()
	__update_draw_color()

@export var enabled_in_editor: bool = false : set = __set_enabled_in_editor
func __set_enabled_in_editor(value: bool):
	if enabled_in_editor == value:
		return
	enabled_in_editor = value
	if __is_editor and not enabled_in_editor:
		position = Vector2.ZERO
	else:
		__update_position()

@export var motion_scale: Vector2 = Vector2.ZERO : set = __set_motion_scale
func __set_motion_scale(value: Vector2):
	if motion_scale == value:
		return
	motion_scale = value
	__update_position()

@export var motion_offset: Vector2 = Vector2.ZERO : set = __set_motion_offset
func __set_motion_offset(value: Vector2):
	if motion_offset == value:
		return
	motion_offset = value
	__update_position()

@export var motion_process_mode: int = ProcessMode.PROCESS

func __update_position() -> void:
	if enabled and (enabled_in_editor or not __is_editor) and is_inside_tree():
		var parent_node_2d: Node2D = get_parent() as Node2D
		if parent_node_2d != null:
			var screen_center_local: Vector2 = (parent_node_2d.get_viewport_transform() * parent_node_2d.get_global_transform()) \
				.affine_inverse() * Vector2(get_viewport_rect().size / 2)
			position = screen_center_local * parent_node_2d.global_scale * motion_scale * parent_node_2d.global_scale + motion_offset
	queue_redraw()

func _process(_delta: float) -> void:
	if __is_editor or motion_process_mode == ProcessMode.PROCESS:
		__update_position()

func _physics_process(delta: float) -> void:
	if not __is_editor and motion_process_mode == ProcessMode.PHYSICS_PROCESS:
		__update_position()

func _draw():
	if __is_editor or get_tree().debug_collisions_hint:
		__draw_arrow(-position, -motion_offset)
		__draw_arrow(-motion_offset, Vector2.ZERO, true)

func _enter_tree():
	# connect to project_settings_changed when signal will be added
	# https://github.com/godotengine/godot/pull/62038
	__on_project_settings_changed()

func _exit_tree():
	# disconnect from project_settings_changed when signal will be added
	# https://github.com/godotengine/godot/pull/62038
	pass

func __update_draw_color():
	__draw_color = __draw_enabled_color if enabled else __draw_disabled_color

func __on_project_settings_changed():
	__draw_enabled_color = ProjectSettings.get_setting("debug/shapes/collision/shape_color") as Color
	var gray = __draw_enabled_color.v
	__draw_disabled_color = Color(gray, gray, gray)
	__update_draw_color()

func __draw_arrow(from: Vector2, to: Vector2, with_triangle: bool = false) -> void:
	from = from.rotated(-rotation) / scale
	to = to.rotated(-rotation) / scale
	draw_circle(from, 2.5, __draw_color)
	if not with_triangle:
		draw_line(from, to, __draw_color, __line_width)
		return
	var distance: float = from.distance_to(to)
	var arrow_size: float = clampf(distance * 2 / 3, __line_width, __max_arrow_size)

	var path: Vector2 = to - from
	if distance < __line_width:
		arrow_size = distance
	else:
		draw_line(from, to - path.normalized() * arrow_size, __draw_color, __line_width)

	draw_colored_polygon(Transform2D(path.angle(), Vector2.ONE * arrow_size, 0, to) * __packed_arrow_points, __draw_color)
