class_name Player
extends Node

var hand : Array[CardMetadata] = []
var freeze_cooldown
func start_freeze_cooldown() -> void:
	freeze_cooldown = get_tree().create_timer(60)

signal hand_updated(data : Dictionary)

var test_hand_metadata : CardMetadata = preload("res://ast/cards/ShiftRegister.tres")

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("debug_action"):
		self.add_card_to_hand(test_hand_metadata)

func add_card_to_hand(card : CardMetadata) -> void:
	hand.append(card)
	emit_signal("hand_updated", {
		"type" : "add",
		"metadata" : card
	})