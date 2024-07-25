class_name ClientUI
extends Control

@onready var card_info_panel : CardInfoPanel = $"%CARD-INFO-PANEL"
@onready var target_sprite : Sprite2D = $TargetSprite

@onready var dev_effect_viewer : EffectResolverViewer = $"%EFFECT-RESOLVER-VIEWER"
@onready var dev_card_viewer : CardDataViewer = $"%CARD-DATA-VIEWER"

var player_areas : Array[PlayerAreaUI] = []
var _player_to_area : Dictionary = {} # [Player, PlayerAreaUI]
var local_player_area : PlayerAreaUI 

signal client_ui_setup()

func setup(config : NetworkPlayStageConfiguration) -> void:
	var t : String = "Server" if MultiplayerManager.is_instance_server() else "Client"
	$"%MULTIPLAYER-PANEL".text = t
	$"%MULTIPLAYER-PANEL".name = t

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
		_player_to_area[player] = player_area
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

	grid_cont.columns = grid_size
	for c_idx in range(0, grid_size):
		grid_cont.get_child(c_idx).flipped = true

	for pa in player_areas:
		var leader : CardBackend = pa.associated_player.leader.get_object()
		var leader_stats := IStatisticPossessor.id(pa.associated_player.leader)
		leader_stats.set_statistic(Genesis.Statistic.POSITION, Vector2.ZERO)

	client_ui_setup.emit()
	self.refresh_ui()

	Router.backend.effect_resolver.finished_resolving_effects_for_frame.connect(update_ui)

func update_ui() -> void:
	var ef : EffectResolver = Router.backend.effect_resolver
	for action in ef.yet_to_process_actions + ef.already_processed_actions:
		reflect_action(action)
	
func reflect_action(action : Action) -> void:
	var player : Player = Router.backend.peer_id_to_player[action.player_peer_id]
	var player_area : PlayerAreaUI = _player_to_area[player]
	if action is CreatureAction:
		if action is CreatureActivateAction:
			var ci : ICardInstance = action.to_effect().creature
			player_area.field_ui.refresh_card(ci)
		elif action is CreatureTargetAction:
			var ef : CreatureTargetEffect = action.to_effect()
			player_area.field_ui.refresh_card(ef.creature)
			if ef.target != null:
				_player_to_area[ef.target.player].field_ui.refresh_card(ef.target)
		else:
			print("huh")
	elif action is HandAction:
		player_area.hand_ui.refresh_hand()
		if action is HandPlayCardAction:
			player_area.field_ui.refresh_field()
	elif action is CursorAction:
		player_area._move_cursor()
	else:
		print("huh")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta : float) -> void:
	#if get_window().gui_get_focus_owner() != Router.client_ui: return
	if Input.is_action_just_pressed("debug_action"):
		AuthoritySourceProvider.authority_source.request_action(
			HandDrawCardAction.setup()
		)

	if Input.is_action_just_pressed("ui_inspect"):
		if hovered_card != null:
			card_info_panel.set_card_metadata(hovered_card.metadata)
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

	if Input.is_action_just_pressed("hand_burn"):
		AuthoritySourceProvider.authority_source.request_action(
			HandBurnHandAction.setup()
		)

	if Input.is_action_just_pressed("debug_advance_frame"):
		AuthoritySourceProvider.authority_source.execute_frame()

func get_player_area(player : Player) -> PlayerAreaUI:
	return _player_to_area[player]

func refresh_ui() -> void:
	for pa in player_areas:
		pa.refresh_ui()

var hovered_card : ICardInstance = null

func update_target_sprite(target : ICardInstance) -> void:
	target = target.get_object()
	if target == null: target_sprite.hide()
	else:
		target_sprite.show()
		target_sprite.position = target.position
