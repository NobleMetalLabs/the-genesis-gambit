class_name PackStack
extends Resource

var _tribe : Genesis.CardTribe
var _contents : Array[PackMetadata]
var _filter_rarity : Dictionary = {
	"Common": [],
	"Rare": [],
	"Mythic": [],
	"Epic": []
}
var _filter_type : Dictionary = {
	"Instant": [],
	"Attacker": [],
	"Support": []
}

func get_contents() -> Array[PackMetadata]:
	return _contents

func get_contents_of_rarity(rarity: String) -> Array[PackMetadata]:
	if rarity == "All": return _contents
	return _filter_rarity[rarity]

func get_contents_of_type(type: String) -> Array[PackMetadata]:
	if type == "All": return _contents
	return _filter_type[type]

func get_tribe() -> Genesis.CardTribe:
	return _tribe

func add_pack(pack: PackMetadata) -> void:
	_contents.push_back(pack)
	_filter_rarity[pack.rarity].push_back(pack)
	_filter_type[pack.type].push_back(pack)

func remove_pack(pack: PackMetadata) -> void:
	_contents.remove_at(_contents.rfind(pack))
	_filter_rarity[pack.rarity].erase(pack)
	_filter_type[pack.type].erase(pack)
