class_name ClientUI
extends Control

@onready var card_info_panel : CardInfoPanel = $"%CARD-INFO-PANEL"
@onready var target_sprite : Sprite2D = $TargetSprite


@onready var dev_effect_viewer : EffectResolverViewer = $"%EFFECT-RESOLVER-VIEWER"
@onready var dev_card_viewer : CardDataViewer = $"%CARD-DATA-VIEWER"

var player_areas : Array[PlayerAreaUI] = []
var local_player_area : PlayerAreaUI 

func setup(config : NetworkPlayStageConfiguration) -> void:
	self.get_tree().get_root().content_scale_size = Vector2.ZERO

	var t : String = "Server" if MultiplayerManager.is_instance_server() else "Client"
	$"%MULTIPLAYER-PANEL".text = t
	$"%MULTIPLAYER-PANEL".name = t

	var pui_template : = $"%PUI-TEMPLATE"
	var grid_cont : GridContainer = $"PlayerAreaGridContainer"
	for nplayer in config.players:
		var player : Player = Router.gamefield.network_player_to_player[nplayer]
		var player_area := pui_template.duplicate()
		player_area.associated_player = player
		player_area.name = "PA-%s" % player.name
		player_area.visible = true
		grid_cont.add_child(player_area)
		player_areas.append(player_area)
		if player == Router.gamefield.local_player:
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

func _input(event : InputEvent) -> void:
	if not event is InputEventKey: return
	if Input.is_action_just_pressed("ui_inspect"):
		var hovered_card : ICardInstance = local_player_area.get_hovered_card()
		if hovered_card != null:
			card_info_panel.set_card_metadata(hovered_card.metadata)
			card_info_panel.display()
			dev_card_viewer.set_card(hovered_card)
		else:
			card_info_panel.undisplay()
			dev_card_viewer.set_card(null)

	# if Input.is_action_just_pressed("ui_activate"):
	# 	var hovered_card := ICardInstance.id(gamefield.get_hovered_card())
	# 	if hovered_card != null:
	# 		AuthoritySourceProvider.authority_source.request_action(
	# 			CreatureActivateAction.setup_with_instances(hovered_card.get_object())
	# 		)

func update_target_sprite(target : ICardInstance) -> void:
	target = target.get_object()
	if target == null: target_sprite.hide()
	else:
		target_sprite.show()
		target_sprite.position = target.position

var current_card_ghost : CardGhost = null

func _create_card_ghost(hand_card : CardInHand) -> void:
	var new_card_ghost := CardGhost.new(hand_card)
	self.add_child(new_card_ghost, true)
	
	new_card_ghost.was_placed.connect(
		func(_position : Vector2) -> void:
			var card_instance := ICardInstance.id(hand_card)
			IStatisticPossessor.id(card_instance).set_statistic(
				Genesis.Statistic.POSITION, _position
			)
			Router.gamefield.effect_resolver.request_effect(HandRemoveCardEffect.new(
				card_instance, card_instance.player, hand_card, Genesis.LeaveHandReason.PLAYED
			))
	)

	current_card_ghost = new_card_ghost
