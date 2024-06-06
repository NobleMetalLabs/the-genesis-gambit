#class_name CardDB
extends Node

var cards : Array[CardMetadata]

func _ready() -> void:
	_scan_cards()
	_assign_ids()

func get_card_by_id(id : int) -> CardMetadata:
	return cards[id]

func get_card_count() -> int:
	return cards.size()

func _scan_cards() -> void:
	cards = _scan_path_for_cards()

func _scan_path_for_cards(path : String = "res://ast/game/cards/meta/") -> Array[CardMetadata]:
	var scanned_cards : Array[CardMetadata] = []
	var dir := DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name : String = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				scanned_cards.append_array(_scan_path_for_cards(path + file_name + "/"))
			else:
				var obj : Object = load(path + file_name.trim_suffix(".remap").trim_suffix(".import"))
				if obj is CardMetadata:
					scanned_cards.append(obj)
			file_name = dir.get_next()
	return scanned_cards

func _assign_ids() -> void:
	for i in range(cards.size()):
		cards[i].id = i