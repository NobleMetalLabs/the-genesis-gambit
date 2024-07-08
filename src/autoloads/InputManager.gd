#class_name InputManager
extends Node

var test_hand_metadata : CardMetadata = preload("res://ast/game/cards/meta/ShiftRegister.tres")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	#if get_window().gui_get_focus_owner() != Router.client_ui: return
	if Input.is_action_just_pressed("debug_action"):
		AuthoritySourceProvider.authority_source.request_action(
			HandDrawCardAction.setup()
		)
	# if Input.is_action_just_pressed("hand_burn"):
	# 	AuthoritySourceProvider.authority_source.request_action(
	# 		HandBurnHandAction.setup(
	# 			Router.gamefield.players[0],
	# 		)
	# 	)
	if Input.is_action_just_pressed("debug_advance_frame"):
		AuthoritySourceProvider.authority_source.execute_frame()
		