class_name ObjectDB
extends Node

class _CardInstanceOnField:
	const scene : PackedScene = preload("res://scn/game/CardInstanceOnField.tscn")
	static func create(gamefield : Gamefield, metadata : CardMetadata, player_owner : Player) -> CardInstanceOnField:
		var new_obj : CardInstanceOnField = scene.instantiate()
		new_obj._setup(gamefield, metadata, player_owner)
		return new_obj

class _CardInstanceInHand:
	const scene : PackedScene = preload("res://scn/ui/CardInstanceInHand.tscn")
	static func create(hand_ui : HandUI, metadata : CardMetadata) -> CardInstanceInHand:
		var new_obj : CardInstanceInHand = scene.instantiate()
		new_obj._setup(hand_ui, metadata)
		return new_obj

class _TempCard: #Rename? CardInstanceGhost?
	const scene : PackedScene = preload("res://scn/ui/TempCard.tscn")
	static func create(card_instance_in_hand_mirror : CardInstanceInHand, metadata : CardMetadata) -> TempCard:
		var new_obj : TempCard = scene.instantiate()
		new_obj._setup(card_instance_in_hand_mirror, metadata)
		return new_obj