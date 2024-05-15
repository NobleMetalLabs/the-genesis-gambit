#class_name InputManager
extends Node

var test_hand_metadata : CardMetadata = preload("res://ast/game/cards/meta/ShiftRegister.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("debug_action"):
		AuthoritySourceProvider.provider.request_action({
			"type" : "hand",
			"action" : "add_card",
			"data" : {
				"metadata_id" : test_hand_metadata.id
			}
		})
	if Input.is_action_just_pressed("hand_burn"):
		AuthoritySourceProvider.provider.request_action({
			"type" : "hand",
			"action" : "burn_hand",
		})