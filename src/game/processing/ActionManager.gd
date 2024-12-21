class_name ActionManager
extends RefCounted

var game_access_manager : GameAccessManager

func _init(_gam : GameAccessManager) -> void:
	game_access_manager = _gam
	
	MultiplayerManager.received_network_message.connect(
		func(_sender : NetworkPlayer, message : String, args : Array) -> void:
			match(message):
				"action-request": handle_action_request(args[0])
	)

func request_action(action : Action) -> void:
	MultiplayerManager.send_network_message("action-request", [action])

func execute_action(action : Action) -> void:
	if action is CommandAction:
		CommandServer.run_command(action.command_string)

var actions_by_gametick : Dictionary = {} # {int : Array[Action]}
func handle_action_request(new_action : Action) -> void:
	actions_by_gametick.get_or_add(new_action.gametick, [] as Array[Action]).append(new_action)
	
	if new_action.gametick <= game_access_manager._current_gametick:
		var my_gametick : int = game_access_manager._current_gametick
		
		if new_action.gametick < game_access_manager._current_gametick: 
			print("should be only 1 of me")
			game_access_manager.revert_to_gametick(new_action.gametick)
			catchup(my_gametick)

func catchup(gametick: int) -> void:
	while(game_access_manager._current_gametick < gametick):
		print("rolling forward tick %d" % game_access_manager._current_gametick)
		game_access_manager.advance_gametick()

func run_actions_on_gametick(gametick : int) -> void:
	if not actions_by_gametick.has(gametick): return
	for action : Action in actions_by_gametick[game_access_manager._current_gametick]:
		execute_action(action)
