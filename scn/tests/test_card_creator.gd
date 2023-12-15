extends Node

var shift_reg_meta : CardMetadata = preload("res://ast/cards/ShiftRegister.tres")

func _ready() -> void:
	var gamefield_manager : GamefieldManager = get_parent().get_node("Gamefield").get_node("GamefieldManager")

	gamefield_manager.place_card(null, shift_reg_meta, Vector2(400, 400))
	gamefield_manager.place_card(null, shift_reg_meta, Vector2(500, 400))
	gamefield_manager.place_card(null, shift_reg_meta, Vector2(600, 400))
	gamefield_manager.place_card(null, shift_reg_meta, Vector2(700, 400))

