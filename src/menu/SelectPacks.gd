extends Node

func _ready() -> void:
	scan_packs("res://ast/cardpacks")

var all_packs : Dictionary = {
	"Common": [],
	"Rare": [],
	"Mythic": [],
	"Epic": []
}

func scan_packs(path : String) -> void:
	var pack_list : PackedStringArray = DirAccess.get_files_at(path)
	
	for file_name : String in pack_list:
		var new_pack : CardPack = load(path + "/" + file_name)
		all_packs[new_pack.rarity].append(new_pack)
	
	print(all_packs)
