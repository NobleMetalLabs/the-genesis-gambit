class_name CardInstance
extends Control

@export var metadata : CardMetadata

func get_vector_to_edge_at_angle(angle : float) -> Vector2:
	# TODO: Make this shit better
	var half_bounds : Vector2 = metadata.image.get_size() / 2
	var tri_angle : float = abs(Vector2.from_angle(angle)).angle()
	var bleed : float = 0.2
	var to_edge : Vector2
	if half_bounds.angle() < tri_angle:
	 	#Vertical Edge
		to_edge = Vector2.from_angle(angle) * Vector2(half_bounds.y, tan((PI / 2) - tri_angle) * half_bounds.y).length()
	else:
		#Horizontal Edge
		to_edge = Vector2.from_angle(angle) * Vector2(half_bounds.x, tan(tri_angle) * half_bounds.x).length()
	return to_edge * (1 - bleed)


