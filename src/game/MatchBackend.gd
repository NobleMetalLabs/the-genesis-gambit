class_name MatchBackend
extends Node

signal game_completed()

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
		MultiplayerManager.send_network_message("backend/setup", [npsc])
	)

	MultiplayerManager.received_network_message.connect(handle_network_message)

func handle_network_message(_sender : NetworkPlayer, message : String, args : Array) -> void:
	match(message):
		"backend/setup":
			setup(args[0])

func setup(config : NetworkPlayStageConfiguration) -> void:
	for nplayer : NetworkPlayer in config.players:
		var player_deck : Deck = config.decks_by_player_uid[nplayer.peer_id]
		var player := Player.setup(player_deck)
		player.name = nplayer.player_name
		peer_id_to_player[nplayer.peer_id] = player
		player_to_peer_id[player] = nplayer.peer_id
		for card_in_deck : CardInDeck in player.cards_in_deck:
			var ci := ICardInstance.id(card_in_deck)
			UIDDB.register_object(ci, 
				nplayer.peer_id * ci.metadata.id
			)
		if nplayer.peer_id == MultiplayerManager.network_player.peer_id:
			local_player = player
		players.append(player)
		self.add_child(player, true)

	Router.client_ui.setup(config)

func get_backend_state() -> MatchBackendState:
	return MatchBackendState.new(players)

func _process(_delta : float) -> void: 
	for player : Player in []: #players:
		var leader_stats := IStatisticPossessor.id(player.leader)
		if leader_stats.get_statistic(Genesis.Statistic.JUST_DIED):
			self.game_completed.emit()
