extends Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position:x", -100, 2)
	tween.tween_property(self, "position:x", 100, 2)
	tween.set_loops()

