extends Node2D

func _ready() -> void:
	$Destructible/CollisionPolygon2D.polygon = $Polygon2D.polygon
	
func clip(poly):
	var offset_poly = Polygon2D.new()
	
	# Transform the polygon values to take into account the transform
	offset_poly.polygon = poly.global_transform * (poly.polygon)
	
	#Subtract the other polygon from the terrain polygon
	var res = Geometry2D.clip_polygons($Polygon2D.polygon, offset_poly.polygon)

	$Polygon2D.polygon = res[0]
	$Destructible/CollisionPolygon2D.set_deferred("polygon", res[0])

	# Free the polygon to avoid memory leak
	offset_poly.queue_free()
