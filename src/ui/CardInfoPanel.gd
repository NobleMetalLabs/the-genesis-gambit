class_name CardInfoPanel
extends Panel

@onready var card_display : CardDisplay = $"%CARD-DISPLAY"

func set_card_metadata(metadata : CardMetadata) -> void:
	card_display.set_metadata(metadata)

var displayed : bool = false

func display() -> void:
	if displayed: return
	var tween : Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position:x", 659, 1)
	tween.tween_callback(func() -> void: self.displayed = true)

func undisplay() -> void:
	if not displayed: return
	var tween : Tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	tween.tween_property(self, "position:x", 960, 1)
	tween.tween_callback(func() -> void: self.displayed = false)
		