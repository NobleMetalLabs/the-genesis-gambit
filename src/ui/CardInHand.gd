class_name CardInHand
extends Control

# TODO: Change the way CardInstance possessors are created to use a constructor with Identifier composition. Move the Controls nodes to a scene that is instantced in _init().

#implements ICardInstance
var metadata : CardMetadata :
	get:
		return ICardInstance.id(self).metadata
	set(value):
		ICardInstance.id(self).metadata = value

#implements ITargetable
func get_boundary_rectangle() -> Rect2:
	return texture_rect.get_global_rect()

@onready var texture_rect : TextureRect = $TextureRect
@onready var border_component : CardBorderComponent = $TextureRect/CardBorderComponent
var hand_ui : HandUI

func _ready() -> void:
	texture_rect.texture = metadata.image
	border_component.set_rarity(metadata.rarity)

func _setup(_hand_ui : HandUI, _metadata : CardMetadata) -> void:
	hand_ui = _hand_ui
	metadata = _metadata
	
func _gui_input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return

	var new_card_ghost : CardGhost = hand_ui.client_ui.request_card_ghost(ICardInstance.id(self))
	new_card_ghost.was_placed.connect(
		func(_position : Vector2) -> void:
			var gamefield : Gamefield = hand_ui.client_ui.gamefield
			var new_card : CardOnField = ObjectDB._CardOnField.create(gamefield, new_card_ghost.metadata)
			AuthoritySourceProvider.authority_source.request_action(
				CreatureSpawnAction.new(
					new_card,
					_position,
				)
			)
			AuthoritySourceProvider.authority_source.request_action(
				HandRemoveCardAction.new(
					Player.new(),
					self,
					HandRemoveCardAction.LeaveReason.PLAYED,
					HandRemoveCardAction.CardRemoveAnimation.PLAY,
				)
			)
	)
