class_name CardInfoPanel
extends Panel

@onready var card_display : UIFullCard = $"%CARD-DISPLAY"
@onready var data_viewer : CardDataViewer = $"%CARD-DATA-VIEWER"

func set_card(card : ICardInstance) -> void:
	card_display.set_metadata(card.metadata)
	data_viewer.set_card(card)

var displayed : bool = false

func display() -> void:
	if displayed: return
	var tween : Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var win_size : Vector2 = self.get_tree().get_root().size
	tween.tween_property(self, "position:x", win_size.x - self.size.x, 0.5)
	tween.tween_callback(func() -> void: self.displayed = true)

func undisplay() -> void:
	if not displayed: return
	var tween : Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	var win_size : Vector2 = self.get_tree().get_root().size
	tween.tween_property(self, "position:x", win_size.x, 0.5)
	tween.tween_callback(func() -> void: self.displayed = false)
		
