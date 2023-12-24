class_name ClientUI
extends Control

@export var temp_card_scn : PackedScene
@onready var card_info_panel : CardInfoPanel = $"%CARD-INFO-PANEL"
@onready var target_sprite : Sprite2D = $TargetSprite
@onready var hand_container : HBoxContainer = $HandContainer

@export var gamefield : Gamefield

func _input(event : InputEvent) -> void:
	if not event is InputEventKey: return
	if Input.is_action_just_pressed("ui_inspect"):
		var hovered_card : CardInstance = gamefield.get_hovered_card()
		if hovered_card != null:
			card_info_panel.set_card_metadata(hovered_card.metadata)
			card_info_panel.display()
			#update_target_sprite(hovered_card.target)
		else:
			card_info_panel.undisplay()
			#update_target_sprite(null)

func update_target_sprite(target : CardInstance) -> void:
	if target == null: target_sprite.hide()
	else:
		target_sprite.show()
		target_sprite.position = target.position

# i guess this should be done individually when cards get added, rather than a for loop
# (can't do that yet since they're already in the scene for now)
func _ready() -> void: setup_hand()
func setup_hand() -> void:
	for card : CardInstanceInHand in hand_container.get_children():
		card.gui_input.connect(
		func (event : InputEvent) -> void:
				if not event is InputEventMouseButton: return
				if event.button_index == MOUSE_BUTTON_LEFT:
					if event.pressed: card_button_down(card.metadata)
		)

func card_button_down(metadata : CardMetadata) -> void:
	var new_temp_card : TempCard = temp_card_scn.instantiate() 
	new_temp_card._setup(self, metadata)
	self.add_child(new_temp_card, true)
