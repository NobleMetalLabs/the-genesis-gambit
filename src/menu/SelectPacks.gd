extends Node

@export var cardpack_path : String = "res://ast/game/cardpacks/data"
func _ready() -> void:
	scan_packs(cardpack_path)
 
var all_packs : Dictionary = {
	"Common": [],
	"Rare": [],
	"Mythic": [],
	"Epic": []
}

func scan_packs(path : String) -> void:
	var pack_list : PackedStringArray = DirAccess.get_files_at(path)
	
	for file_name : String in pack_list:
		var new_pack : PackMetadata = load(path + "/" + file_name)
		all_packs[new_pack.rarity].append(new_pack)

func show_packs_by_rarity(rarity : String) -> void:
	var displayed_packs : Array = all_packs[rarity]
	print(displayed_packs)
