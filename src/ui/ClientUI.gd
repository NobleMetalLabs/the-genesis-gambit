class_name ClientUI
extends Control

@onready var card_info_panel : CardInfoPanel = $"%CARD-INFO-PANEL"
@onready var target_sprite : Sprite2D = $TargetSprite
@onready var hand_ui : HandUI = $"%HAND-UI"

func _ready() -> void:
	var player : Player = Player.new() #TODO: change this 
	player.name = "Player"
	gamefield.add_child(player)

	UIEventBus.reflect_action.connect(handle_ui_event)
	UIEventBus.UI_root = self

@export var gamefield : Gamefield

func _input(event : InputEvent) -> void:
	if not event is InputEventKey: return
	if Input.is_action_just_pressed("ui_inspect"):
		if hand_ui.hovered_hand_card != null:
			card_info_panel.set_card_metadata(hand_ui.hovered_hand_card.metadata)
			card_info_panel.display()
		else:
			var hovered_card : ICardInstance = ICardInstance.id(gamefield.get_hovered_card())
			if hovered_card != null:
				card_info_panel.set_card_metadata(hovered_card.metadata)
				card_info_panel.display()
				#update_target_sprite(hovered_card.target)
			else:
				card_info_panel.undisplay()
				#update_target_sprite(null)

func get_hovered_card() -> ICardInstance:
	var gc : ICardInstance = ICardInstance.id(gamefield.get_hovered_card())
	var hnd : ICardInstance = ICardInstance.id(hand_ui.hovered_hand_card)
	if gc != null: return gc
	if hnd != null: return hnd
	return null

func update_target_sprite(target : ICardInstance) -> void:
	target = target.get_object()
	if target == null: target_sprite.hide()
	else:
		target_sprite.show()
		target_sprite.position = target.position

func handle_ui_event(action : Action) -> void:
	if not action is CustomAction: return
	action = action as CustomAction
	if action.name == "player_card_ghost_requested":
		_create_card_ghost(action.data["card_in_hand"])
	else:
		print("Unknown action: ", action.name)

func _create_card_ghost(hand_card : CardInHand) -> void:
	var new_card_ghost := CardGhost.new(hand_card)
	self.add_child(new_card_ghost, true)
	
	new_card_ghost.was_placed.connect(
		func(_position : Vector2) -> void:
			var new_card := CardOnField.new(gamefield, [
				ICardInstance.dupe(hand_card),
				IStatisticPossessor.id(hand_card).duplicate(),
				IMoodPossessor.id(hand_card).duplicate(),
			])
			AuthoritySourceProvider.authority_source.request_action(
				CreatureSpawnAction.new(
					new_card,
					_position,
				)
			)
			AuthoritySourceProvider.authority_source.request_action(
				HandRemoveCardAction.new(
					Player.new(),
					hand_card,
					HandRemoveCardAction.LeaveReason.PLAYED,
					HandRemoveCardAction.CardRemoveAnimation.PLAY,
				)
			)
	)
