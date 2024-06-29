#class_name CardDB
extends Node

var cards : Array[CardMetadata]
var _path_by_cards : Dictionary = {} #[CardMetadata, String]
var _id_by_name : Dictionary = {} #[String, int]

func _ready() -> void:
	_scan_cards()
	_assign_ids()
	_assign_tribes()

func get_card_by_id(id : int) -> CardMetadata:
	return cards[id]

func get_id_by_name(card_name : String) -> int:
	return _id_by_name[card_name]

func get_card_count() -> int:
	return cards.size()

func get_cards_by_tribe(tribe : Genesis.CardTribe) -> Array[CardMetadata]:
	var tribe_cards : Array[CardMetadata] = []
	for card in cards:
		if card.tribe == tribe:
			tribe_cards.append(card)
	return tribe_cards 

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
					_path_by_cards[obj] = path + file_name
			file_name = dir.get_next()
	return scanned_cards

func _assign_ids() -> void:
	for i in range(cards.size()):
		cards[i].id = i
		_id_by_name[cards[i].name] = i

func _assign_tribes() -> void:
	for card in cards:
		var path : String = _path_by_cards[card].get_base_dir()
		var tribe_text : String = path.substr(path.rfind("/") + 1)
		var tribe : Genesis.CardTribe = Genesis.CardTribe.keys().find(tribe_text.to_upper()) as Genesis.CardTribe
		card.tribe = tribe