extends Node

func _ready() -> void:
	register_commands()

func register_commands() -> void:
	CommandServer.register_command(
		CommandBuilder.new()
			.Literal("card")
			.Literal("spawn")
			.Key("name", CardDB.get_card_names)
				.Tag("card-id", "int", CardDB.get_id_by_name)
			.Validated("player-num", GlobalCommandValidators.is_valid_int_positive)
				.Tag_gn("int")
			.Callback(spawn_card, ["card-id", "player-num"])
		.Build()
	)

	CommandServer.register_command(
		CommandBuilder.new()
			.Literal("card")
			.Literal("act")
			.Key("uid", _get_uiddb_uids)
				.Tag_gn("int")
			.Literal("event")
			.Branch()
				.Literal("entered-field-event")
					.Tag_st("event-type")
			.EndBranch()
			.Callback(issue_event_to_card, ["uid", "event-type"])
		.Build()
	)

@onready var cards_holder : Node = get_node("%Cards")
var processor : CardProcessor = CardProcessor.new()

var players : Dictionary = {} #[int, Player]

func spawn_card(id : int, player_num : int) -> void:
	var player : Player = players.get(player_num, _new_player(player_num))
	var component := ICardInstance.new(CardDB.get_card_by_id(id), player)
	component.logic.verbose = true
	var new_ent := CardBackend.new(component)
	cards_holder.add_child(new_ent)
	UIDDB.register_object(new_ent, 
		hash(new_ent)
	)

func _new_player(num : int) -> Player:
	var player : Player = Player.setup(Deck.EMPTY)
	player.name = "P%d" % [num]
	players[num] = player
	return player

func issue_event_to_card(uid : int, event_type : String) -> void:
	var ent := UIDDB.object(uid)
	var card := ICardInstance.id(ent)
	var event : Event
	match event_type:
		"entered-field-event":
			event = EnteredFieldEvent.new(card)
		_:
			push_error("Unknown event type: %s" % [event_type])
	processor.process_event(event)

func _get_uiddb_uids() -> Array[StringName]:
	var output : Array[StringName] = []
	output.assign(UIDDB.uid_to_object.keys().map(func to_sn(uid : int) -> StringName: return str(uid)))
	return output

# func is_uid_of_existing_card(value : String) -> bool:
# 	if not value.is_valid_int(): return false
# 	var uid := value.to_int()
# 	if not UIDDB.has_uid(uid): return false
# 	var obj := UIDDB.object(uid)
# 	var ci := ICardInstance.id(obj)
# 	return ci != null