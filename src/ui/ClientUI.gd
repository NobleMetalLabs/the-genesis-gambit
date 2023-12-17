class_name ClientUI
extends Control

@export var temp_card_scn : PackedScene
@onready var card_info_panel : CardInfoPanel = $"%CARD-INFO-PANEL"

@export var gamefield : Gamefield

# debug
var shift_reg_meta : CardMetadata = preload("res://ast/cards/ShiftRegister.tres")

func _on_button_button_down() -> void:
	var new_temp_card : TempCard = temp_card_scn.instantiate() 
	new_temp_card._setup(self, shift_reg_meta)
	self.add_child(new_temp_card, true)

func _input(event : InputEvent) -> void:
	if not event is InputEventKey: return
	if Input.is_action_just_pressed("ui_inspect"):
		var hovered_card : CardInstance = gamefield.get_hovered_card()
		if hovered_card != null:
			card_info_panel.set_card_metadata(hovered_card.metadata)
			card_info_panel.display()
		else:
			card_info_panel.undisplay()
	
