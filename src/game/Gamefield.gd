class_name Gamefield
extends Node

signal game_completed()
signal event(name : StringName, data : Dictionary)

var cards_holder : Node2D

var client_ui : ClientUI
var effect_resolver : EffectResolver = EffectResolver.new()

var players : Array[Player]
var peer_id_to_player : Dictionary = {} # [int, Player]
var player_to_peer_id : Dictionary = {} # [Player, int]
var local_player : Player

func _ready() -> void:
	# debug npsc creation for setup
	MultiplayerManager.network_update.connect(func() -> void:
		if MultiplayerManager.peer_id_to_player.keys().size() < 2: return
		if not MultiplayerManager.is_instance_server(): return

		var nps : Array[NetworkPlayer] = []
		nps.assign(MultiplayerManager.peer_id_to_player.values())
		var decks_by_player_uid : Dictionary = {}
		for np in nps:
			decks_by_player_uid[np.peer_id] = Deck.prebuilt_from_tribe(Genesis.CardTribe.BUGS)
		var npsc := NetworkPlayStageConfiguration.setup(nps, decks_by_player_uid)
		MultiplayerManager.send_network_message("gamefield/setup", [npsc])
	)

	MultiplayerManager.received_network_message.connect(handle_network_message)

func handle_network_message(_sender : NetworkPlayer, message : String, args : Array) -> void:
	match(message):
		"gamefield/setup":
			setup(args[0])

func setup(config : NetworkPlayStageConfiguration) -> void:
	#cards_holder = get_node("Cards")
	for nplayer : NetworkPlayer in config.players:
		var player_deck : Deck = config.decks_by_player_uid[nplayer.peer_id]
		var player := Player.new(player_deck)
		player.name = nplayer.player_name
		peer_id_to_player[nplayer.peer_id] = player
		player_to_peer_id[player] = nplayer.peer_id
		if nplayer.peer_id == MultiplayerManager.network_player.peer_id:
			print("Local player found")
			local_player = player
		players.append(player)
	 	#player.leader = ICardInstance.new(player_deck.leader, player)
	 	#var leader : CardOnField = CardOnField.new([player.leader])
	 	#place_card(leader, Vector2(960, 540 * 1.5))
		self.add_child(player, true)

	Router.client_ui.setup(config)


var _hovered_card : CardOnField = null
func get_hovered_card() -> CardOnField:
	return _hovered_card

func get_gamefield_state() -> GamefieldState:
	return GamefieldState.new(players)

func _process(_delta : float) -> void: 
	pass
	# for player in players:
	# 	var leader_stats := IStatisticPossessor.id(player.leader)
	# 	if leader_stats.get_statistic(Genesis.Statistic.JUST_DIED):
	# 		self.game_completed.emit()
			
func place_card(card : CardOnField, position : Vector2) -> void:
	card.position = position

	self.event.connect(func(event_name : StringName, data : Dictionary) -> void:
		card.logic.process_event(event_name, data)
	)
	card.card_frontend.mouse_entered.connect(
		func() -> void:
			_hovered_card = card
	)
	card.card_frontend.mouse_exited.connect(
		func() -> void:
			_hovered_card = null
	)

	cards_holder.add_child(card, true)
