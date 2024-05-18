class_name Player
extends Node

var hand : Array[CardMetadata] = []

func _ready() -> void:
	AuthoritySourceProvider.authority_source.reflect_action.connect(_handle_player_action)

func _handle_player_action(action : Action) -> void:
	if not action is PlayerAction: return

	if action is HandAddCardAction:
		var add_action : HandAddCardAction = action as HandAddCardAction
		var card_meta : CardMetadata = CardDB.get_card_by_id(add_action.card_metadata_id)
		hand.append(card_meta)
		return

	if action is HandBurnHandAction:
		var num_cards : int = hand.size()
		hand.clear()
		for i in range(num_cards):
			AuthoritySourceProvider.authority_source.request_action(
				HandAddCardAction.new(self, false, true, 0)
			)
		return

	if action is HandRemoveCardAction:
		var remove_action : HandRemoveCardAction = action as HandRemoveCardAction
		hand.erase(remove_action.card.metadata)
		return
