class_name ObjectDB
extends Node

class _CardOnField:
	const scene : PackedScene = preload("res://scn/game/CardOnField.tscn")
	static func create(gamefield : Gamefield, metadata : CardMetadata) -> CardOnField:
		var new_obj : CardOnField = scene.instantiate()
		new_obj._setup(gamefield, metadata)
		return new_obj

class _CardInHand:
	const scene : PackedScene = preload("res://scn/ui/CardInHand.tscn")
	static func create(hand_ui : HandUI, metadata : CardMetadata) -> CardInHand:
		var new_obj : CardInHand = scene.instantiate()
		new_obj._setup(hand_ui, metadata)
		return new_obj

class _CardGhost:
	const scene : PackedScene = preload("res://scn/ui/CardGhost.tscn")
	static func create(card_instance_in_hand_mirror : CardInHand, metadata : CardMetadata) -> CardGhost:
		var new_obj : CardGhost = scene.instantiate()
		new_obj._setup(card_instance_in_hand_mirror, metadata)
		return new_obj
