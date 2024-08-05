class_name MatchBackend
extends Node

signal game_completed()

var effect_resolver : EffectResolver = EffectResolver.new()

var players : Array[Player]
var peer_id_to_player : Dictionary = {} # [int, Player]
var player_to_peer_id : Dictionary = {} # [Player, int]
var local_player : Player

var card_holder : Node
var player_holder : Node

func _ready() -> void:
	MultiplayerManager.received_network_message.connect(handle_network_message)

func handle_network_message(_sender : NetworkPlayer, message : String, args : Array) -> void:
	match(message):
		"backend/setup":
			setup(args[0])

func setup(config : NetworkPlayStageConfiguration) -> void:
	self.card_holder = $"Cards"
	self.player_holder = $"Players"

	for nplayer : NetworkPlayer in config.players:
		var player_deck : Deck = config.decks_by_player_uid[nplayer.peer_id]
		var player := Player.setup(player_deck)
		player.name = nplayer.player_name
		peer_id_to_player[nplayer.peer_id] = player
		player_to_peer_id[player] = nplayer.peer_id
		for ci : ICardInstance in player.cards_in_deck + player.cards_in_hand + player.cards_on_field:
			_create_card_backend(
				ci, "%s-%s<%s>" % [nplayer.peer_id, ci.metadata.id, ci.metadata.name]
			)
			var stats := IStatisticPossessor.id(ci)
			stats.set_statistic(Genesis.Statistic.IS_IN_DECK, ci in player.cards_in_deck)
			stats.set_statistic(Genesis.Statistic.IS_IN_HAND, ci in player.cards_in_hand)
			stats.set_statistic(Genesis.Statistic.IS_ON_FIELD, ci in player.cards_on_field)

		var player_stats := IStatisticPossessor.id(player)
		player_stats.set_statistic(Genesis.Statistic.ENERGY, 0)
		player_stats.set_statistic(Genesis.Statistic.MAX_ENERGY, player.leader.metadata.energy)

		player_stats.set_statistic(Genesis.Statistic.NUM_CARDS, player.cards_in_deck.size())
		player_stats.set_statistic(Genesis.Statistic.NUM_CARDS_MARKED_IN_DECK, 0)
		player_stats.set_statistic(Genesis.Statistic.NUM_CARDS_LEFT_IN_DECK, player.cards_in_deck.size())

		if nplayer.peer_id == MultiplayerManager.network_player.peer_id:
			local_player = player
		players.append(player)
		player_holder.add_child(player, true)

	if MultiplayerManager.is_instance_server():
		var execute_frame_timer : Timer = Timer.new()
		execute_frame_timer.name = "ExecuteFrameTimer"
		execute_frame_timer.wait_time = Genesis.NETWORK_FRAME_PERIOD
		execute_frame_timer.one_shot = false
		execute_frame_timer.autostart = true
		execute_frame_timer.timeout.connect(AuthoritySourceProvider.authority_source.execute_frame)
		add_child(execute_frame_timer)

	AuthoritySourceProvider.authority_source.new_frame_index.connect(
		func(_frame_number : int) -> void:
			effect_resolver.resolve_effects(Router.backend.get_backend_object_collection())
	)

# NOTE: only works if created card order is deterministic across clients. i think it is, but not 100%...
var _created_card_count : int = 1
func get_created_card_number() -> int:
	return _created_card_count

func create_card(instance_id : int, player_owner : Player, internal_name : String) -> ICardInstance:
	_created_card_count += 1
	var ci := ICardInstance.new(CardDB.get_card_by_id(instance_id), player_owner)
	_create_card_backend(ci, internal_name)
	return ci

func _create_card_backend(card_instance : ICardInstance, internal_name : String) -> CardBackend:
	var card_bk := CardBackend.new(card_instance)
	UIDDB.register_object(card_instance, 
		hash(internal_name)
	)
	card_bk.name = internal_name
	card_holder.add_child(card_bk, true)
	return card_bk

func get_backend_object_collection() -> BackendObjectCollection:
	return BackendObjectCollection.new(players)

func _process(_delta : float) -> void: 
	for player : Player in []: #players:
		var leader_stats := IStatisticPossessor.id(player.leader)
		if leader_stats.get_statistic(Genesis.Statistic.WAS_JUST_KILLED):
			self.game_completed.emit()
