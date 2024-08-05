extends Control



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("debug_action"):
		print("UYA")
		var new_card : RigidBody2D = self.get_children()[1].duplicate()
		new_card.position = Vector2(885, 525)
		self.add_child(new_card)
