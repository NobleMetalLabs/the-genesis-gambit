#class_name InputManager
extends Node

var test_hand_metadata : CardMetadata = preload("res://ast/game/cards/meta/ShiftRegister.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("debug_action"):
		AuthoritySourceProvider.authority_source.request_action(
			HandAddCardAction.new(
				Player.new()
			)
		)
	if Input.is_action_just_pressed("hand_burn"):
		AuthoritySourceProvider.authority_source.request_action(
			HandBurnHandAction.new(
				Player.new()
			)
		)