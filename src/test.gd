extends Node


# Called when the node enters the scene tree for the first time.
func _ready():
	var ar = Arrow2D.new()
	ar.position = Vector2(100, 300)
	ar.end_position = Vector2(400, 100)

	call_deferred("add_sibling", ar)
	var t : Tween = get_tree().create_tween()
	t.tween_property(ar, "position:x", 800, 50)
