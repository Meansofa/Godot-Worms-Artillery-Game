extends Node2D

@onready var line = $Line2D

var max_points = 2000.0




func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	$Camera2D.global_position = $Player.global_position + Vector2(0, -250)
	var drag_horizontal_offset = (get_global_mouse_position().x - 1920) / (1920)
	var drag_vertical_offset = (get_global_mouse_position().y - 1080) / (1080)
#	var offset_v = (Vector2(1920/2, 1080/2) - get_global_mouse_position()).normalized()
	$Camera2D.drag_horizontal_offset = drag_horizontal_offset
	$Camera2D.drag_vertical_offset = drag_vertical_offset

func _physics_process(delta: float) -> void:
	update_trajectory(delta)
	
func update_trajectory(delta):
	line.clear_points()
	var pos = $Player/RotPoint/ShootPoint.global_position
	var vel = $Player/RotPoint/ShootPoint.global_transform.x * $Player.bullet_velocity
	for i in max_points:
		line.add_point(pos)
		vel.y += $Player.gravity * delta
		pos += vel * delta
		if Geometry2D.is_point_in_polygon($Terrain/Polygon2D.to_local(pos), $Terrain/Polygon2D.polygon):
			break
