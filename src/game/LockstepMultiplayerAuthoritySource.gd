class_name LockstepMultiplayerAuthoritySource
extends AuthoritySource

var action_queues : Dictionary = {} #[int, Array[Action]]
var self_action_queues : Dictionary = {} #[int, Array[Action]]
var players_input_recieved : Dictionary = {} #[int, Array[int]]

var current_frame_number : int = 0
var sent_inputs : bool = false

func _ready() -> void:
	MultiplayerManager.received_network_message.connect(handle_network_message)

func request_action(action : Action) -> void:
	print("Action requested: %s" % action)
	var existing : Array[Action] = []
	var frame : int = current_frame_number
	if sent_inputs: frame += 1
	existing.assign(self_action_queues.get(frame, []))
	self_action_queues[frame] = existing + [action]
	print("Queued action: %s" % action)

func execute_frame() -> void:
	MultiplayerManager.send_network_message(
		"multiplayer/input_request", [current_frame_number]
	)

func handle_network_message(sender : NetworkPlayer, message : String, args : Array) -> void:
	var action_arr : Array[Action] = [] # I LOVE GODOT ENGINE!!!!!!!
	match(message):
		"multiplayer/input_request":
			handle_input_request(args[0])
		"multiplayer/input_request_response":
			action_arr.assign(args[1])
			handle_input_request_response(sender.peer_id, args[0], action_arr)
		"multiplayer/lockstep_advance_ready_notice":
			handle_lockstep_advance_ready_notice(sender.peer_id)
		"multiplayer/lockstep_advance":
			handle_lockstep_advance(args[0])

func handle_input_request(frame_number : int) -> void:
	var actions : Array[Action] = []
	if action_queues.has(frame_number):
		actions.assign(action_queues[frame_number])

	MultiplayerManager.send_network_message(
		"multiplayer/input_request_response",
		[frame_number, self_action_queues.get(frame_number, [])]
	)
	sent_inputs = true

func handle_input_request_response(sender_id : int, frame_number : int, actions : Array[Action]) -> void:
	print("Received actions: %s" % [actions])
	var existing : Array[Action] = []
	existing = action_queues.get(frame_number, existing)
	existing.append_array(actions)
	action_queues[frame_number] = existing
	
	var players_existing : Array[int] = []
	players_existing = players_input_recieved.get(frame_number, players_existing)
	players_existing.append(sender_id)
	players_input_recieved[frame_number] = players_existing

	if players_input_recieved[frame_number].size() == MultiplayerManager.get_num_players():
		MultiplayerManager.send_network_message(
			"multiplayer/lockstep_advance_ready_notice", []
		)

var players_ready_for_lockstep_advance : Array[int] = []
func handle_lockstep_advance_ready_notice(sender_id : int) -> void:
	if not MultiplayerManager.is_instance_server(): return
	players_ready_for_lockstep_advance.append(sender_id)
	if players_ready_for_lockstep_advance.size() == MultiplayerManager.get_num_players():
		MultiplayerManager.send_network_message(
			"multiplayer/lockstep_advance", [current_frame_number + 1]
		)

func handle_lockstep_advance(new_frame_number : int) -> void:
	if new_frame_number > current_frame_number:
		#TODO: sort the actions for deterministic resolution
		for action : Action in action_queues.get(current_frame_number, []):
			print("%s : $$$$$$$$$$$$$$$$$$$Reflecting action: %s" % [MultiplayerManager.get_peer_id(), action])
			reflect_action.emit(action)

		action_queues.erase(current_frame_number)
		self_action_queues.erase(current_frame_number)
		players_input_recieved.erase(current_frame_number)
		players_ready_for_lockstep_advance.clear()

		current_frame_number = new_frame_number
		print("%s : FRAAAAAAAAAAAAME %s" % [MultiplayerManager.get_peer_id(), current_frame_number])
	sent_inputs = false
	var gf : Gamefield = Router.gamefield
	gf.effect_resolver.resolve_effects(gf.get_gamefield_state())