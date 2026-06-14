# crosshair_ui.gd
extends Control

@export var color: Color = Color.GREEN
@export var line_width: float = 2.0
@export var line_length: float = 8.0
@export var gap: float = 4.0
@export var draw_dot: bool = true
@export var dot_radius: float = 1.5

func _ready() -> void:
	# Center the Control node in the viewport
	anchors_preset = Control.PRESET_CENTER
	grow_horizontal = Control.GROW_DIRECTION_BOTH
	grow_vertical = Control.GROW_DIRECTION_BOTH
	
	# Force a redraw
	queue_redraw()

func _draw() -> void:
	# Center of this Control node is (0,0) because it's centered and has no size or is sized
	# Draw center dot
	if draw_dot:
		draw_circle(Vector2.ZERO, dot_radius, color)
	
	# Draw crosshair lines
	# Left
	draw_line(Vector2(-gap - line_length, 0), Vector2(-gap, 0), color, line_width)
	# Right
	draw_line(Vector2(gap, 0), Vector2(gap + line_length, 0), color, line_width)
	# Top
	draw_line(Vector2(0, -gap - line_length), Vector2(0, -gap), color, line_width)
	# Bottom
	draw_line(Vector2(0, gap), Vector2(0, gap + line_length), color, line_width)
