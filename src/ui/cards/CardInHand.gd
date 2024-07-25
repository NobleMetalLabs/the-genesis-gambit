class_name CardInHand
extends Control

var card_backend : ICardInstance
var card_frontend : CardFrontend

func _init(backend : ICardInstance) -> void:
	self.card_backend = backend

	card_frontend = CardFrontend.instantiate()
	self.add_child(card_frontend)

	self.name = "CardInHand"

func _to_string() -> String:
	return "CardInHand<%s>" % ICardInstance.id(self)

func _gui_input(event : InputEvent) -> void:
	if not event is InputEventMouseButton: return
	if not event.button_index == MOUSE_BUTTON_LEFT: return
	if not event.pressed: return

	var card_stats := IStatisticPossessor.id(card_backend)
	if card_stats.get_statistic(Genesis.Statistic.IS_MARKED): return
	if card_stats.get_statistic(Genesis.Statistic.IS_FROZEN): return

	get_parent().get_parent()._create_card_ghost(self)
