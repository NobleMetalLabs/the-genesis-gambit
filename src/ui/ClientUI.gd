class_name ClientUI
extends Control

@onready var card_info_panel : CardInfoPanel = $"%CARD-INFO-PANEL"
@onready var target_sprite : Sprite2D = $TargetSprite
@onready var hand_ui : HandUI = $"%HAND-UI"

@onready var dev_effect_viewer : EffectResolverViewer = $"%EFFECT-RESOLVER-VIEWER"
@onready var dev_card_viewer : CardDataViewer = $"%CARD-DATA-VIEWER"

var gamefield : Gamefield

func _ready() -> void:
	self.get_tree().get_root().content_scale_size = Vector2.ZERO

func _input(event : InputEvent) -> void:
	if not event is InputEventKey: return
	if Input.is_action_just_pressed("ui_inspect"):
		var hovered_card : ICardInstance = get_hovered_card()
		if hovered_card != null:
			card_info_panel.set_card_metadata(hovered_card.metadata)
			card_info_panel.display()
			dev_card_viewer.set_card(hovered_card)
		else:
			card_info_panel.undisplay()
			dev_card_viewer.set_card(null)

	if Input.is_action_just_pressed("ui_activate"):
		var hovered_card := ICardInstance.id(gamefield.get_hovered_card())
		if hovered_card != null:
			AuthoritySourceProvider.authority_source.request_action(
				CreatureActivateAction.new(hovered_card.get_object())
			)

func get_hovered_card() -> ICardInstance:
	var gc : ICardInstance = ICardInstance.id(gamefield.get_hovered_card())
	var hnd : ICardInstance = ICardInstance.id(hand_ui.hovered_hand_card)
	if gc != null: return gc
	if hnd != null: return hnd
	return null

func refresh_hand_ui() -> void:
	hand_ui._refresh_hand()

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
