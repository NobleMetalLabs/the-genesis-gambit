class_name ClientUI
extends Control

@onready var card_info_panel : CardInfoPanel = $"%CARD-INFO-PANEL"
@onready var postgame_panel : PostgamePanel = $"%POSTGAME-PANEL"

@onready var dev_effect_viewer : EffectResolverViewer = $"%EFFECT-RESOLVER-VIEWER"
@onready var dev_card_viewer : CardDataViewer = $"%CARD-DATA-VIEWER"

var player_areas : Array[PlayerAreaUI] = []
var local_player_area : PlayerAreaUI 

signal client_ui_setup()

func setup(config : NetworkPlayStageConfiguration) -> void:
	var t : String = "Server" if MultiplayerManager.is_instance_server() else "Client"
	$"%MULTIPLAYER-PANEL".text = t
	$"%MULTIPLAYER-PANEL".name = t

	postgame_panel.hide()

	var pui_template : = $"%PUI-TEMPLATE"
	var grid_cont : GridContainer = $"PlayerAreaGridContainer"
	for nplayer in config.players:
		var player : Player = Router.backend.peer_id_to_player[nplayer.peer_id]
		var player_area := pui_template.duplicate()
		player_area.associated_player = player
		player_area.name = "PA-%s" % player.name
		player_area.visible = true
		grid_cont.add_child(player_area)
		player_areas.append(player_area)
		if player == Router.backend.local_player:
			local_player_area = player_area

	pui_template.free()

	var num_players : int = config.players.size()
	var grid_size : int = num_players / 2

	# If the local player is not in the bottom half, swap the grid so they are
	var local_area_idx : int = player_areas.find(local_player_area)
	if local_area_idx < grid_size:
		for pa : PlayerAreaUI in grid_cont.get_children().slice(-grid_size):
			grid_cont.move_child(pa, 0)

	grid_cont.columns = max(1, grid_size)
	for c_idx in range(0, grid_size):
		grid_cont.get_child(c_idx).flipped = true

	for pa in player_areas:
		var leader : CardBackend = pa.associated_player.leader.get_object()
		var leader_stats := IStatisticPossessor.id(pa.associated_player.leader)
		leader_stats.set_statistic(Genesis.Statistic.POSITION, Vector2.ZERO)

	Router.backend.effect_resolver.finished_resolving_effects_for_frame.connect(
		func refresh_cards(cards : Array[ICardInstance]) -> void:
			for card : ICardInstance in cards:
				refresh_card(card)
	)

	client_ui_setup.emit()
	self.force_refresh_ui()

func force_refresh_ui() -> void:
	for pa in player_areas:
		pa.force_refresh_ui()

func refresh_card(card_instance : ICardInstance) -> void:
	#print(card_instance)
	for player_area in player_areas:
		player_area.field_ui.refresh_card(card_instance)
		player_area.hand_ui.refresh_card(card_instance)
		player_area.deck_ui.refresh_card(card_instance)

func display_postgame_ui(player : Player, final_blow_dealer : ICardInstance) -> void:
	postgame_panel.set_contents(player, final_blow_dealer)
	postgame_panel.show()

var _card_instance_to_frontend : Dictionary = {} #[ICardInstance, CardFrontend]
func assign_card_frontend(card_instance : ICardInstance, card_frontend : CardFrontend) -> void:
	_card_instance_to_frontend[card_instance] = card_frontend

func deassign_card_frontend(card_instance : ICardInstance) -> void:
	_card_instance_to_frontend.erase(card_instance)

func get_card_frontend(card_instance : ICardInstance) -> CardFrontend:
	return _card_instance_to_frontend.get(card_instance, null)

func _process(_delta : float) -> void:
	_handle_card_actions()
	_handle_hand_actions()
	_handle_debug_actions()

var hovered_card : ICardInstance = null
func _handle_card_actions() -> void:
	if Input.is_action_just_pressed("ui_inspect"):
		if hovered_card != null and Router.client_ui.get_card_frontend(hovered_card).is_face_visible:
			card_info_panel.set_card_metadata(hovered_card.metadata)
			card_info_panel.card_display.description_label.text = hovered_card.logic.description #lol
			card_info_panel.display()
			dev_card_viewer.set_card(hovered_card)
		else:
			card_info_panel.undisplay()
			dev_card_viewer.set_card(null)

	if Input.is_action_just_pressed("ui_activate"):
		if hovered_card != null:
			if hovered_card.player == Router.backend.local_player:
				AuthoritySourceProvider.authority_source.request_action(
					CreatureActivateAction.setup(hovered_card)
				)

func _handle_hand_actions() -> void:
	if Input.is_action_just_pressed("hand_burn"):
		var player_stats := IStatisticPossessor.id(Router.backend.local_player)
		var burn_cooldown : CooldownEffect = player_stats.get_cooldown_of_type(Genesis.CooldownType.BURN)
		
		if burn_cooldown == null:
			AuthoritySourceProvider.authority_source.request_action(
				HandBurnHandAction.setup()
			)

func _handle_debug_actions() -> void:
	if Input.is_action_just_pressed("debug_action"):
		AuthoritySourceProvider.authority_source.request_action(
			HandDrawCardAction.setup()
		)

	if Input.is_action_just_pressed("debug_advance_frame"):
		AuthoritySourceProvider.authority_source.execute_frame()
