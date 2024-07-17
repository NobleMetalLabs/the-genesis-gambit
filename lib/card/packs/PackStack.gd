class_name PackStack
extends Serializeable

var _leader : CardMetadata
var _contents : Array[PackMetadata]

func get_contents() -> Array[PackMetadata]:
	return _contents

func get_contents_of_rarity(rarity : Genesis.PackRarity) -> Array[PackMetadata]:
	return _contents.filter(func(p: PackMetadata) -> bool: return p.rarity == rarity)

func get_leader() -> CardMetadata:
	return _leader

func add_pack(pack: PackMetadata) -> void:
	_contents.push_back(pack)

func remove_pack(pack: PackMetadata) -> void:
	_contents.remove_at(_contents.rfind(pack))

func _to_string() -> String:
	return "PackStack(<%s>[%s])" % [_leader, _contents]