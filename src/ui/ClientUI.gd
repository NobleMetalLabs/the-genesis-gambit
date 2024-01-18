class_name ClientUI
extends Control

@onready var card_info_panel : CardInfoPanel = $"%CARD-INFO-PANEL"
@onready var target_sprite : Sprite2D = $TargetSprite
@onready var hand_ui : HandUI = $"%HAND-UI"

func _ready() -> void:
	var player : Player = Player.new() #TODO: change this 
	self.add_child(player) #TODO: change this
	hand_ui._setup(self, player)

@export var gamefield : Gamefield

func _input(event : InputEvent) -> void:
	if not event is InputEventKey: return
	if Input.is_action_just_pressed("ui_inspect"):
		if hand_ui.hovered_hand_card != null:
			card_info_panel.set_card_metadata(hand_ui.hovered_hand_card.metadata)
			card_info_panel.display()
		else:
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

func request_temp_card(hand_instance : CardInstanceInHand) -> TempCard:
	var new_temp_card : TempCard = ObjectDB._TempCard.create(hand_instance, hand_instance.metadata)
	self.add_child(new_temp_card, true)
	return new_temp_card
