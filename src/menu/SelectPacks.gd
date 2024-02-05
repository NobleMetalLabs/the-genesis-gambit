extends Node

@export var cardpack_path : String = "res://ast/game/cardpacks/data"
var pack_scene : PackedScene = load("res://scn/ui/UIFullPack.tscn")
@onready var pack_container : GridContainer = $"%GRID-CONTAINER"
@onready var rarity_filter : OptionButton = $"%RARITY-FILTER"
@onready var type_filter : OptionButton = $"%TYPE-FILTER"

func _ready() -> void:
	scan_packs(cardpack_path)

func scan_packs(path : String) -> void:
	var pack_list : PackedStringArray = DirAccess.get_files_at(path)
	
	for file_name : String in pack_list:
		var new_pack_data : PackMetadata = load(path + "/" + file_name)
		var new_pack : UIFullPack = pack_scene.instantiate()
		
		pack_container.add_child(new_pack, true)
		new_pack.set_metadata(new_pack_data)
		new_pack.custom_minimum_size = Vector2(135,200)

var selected_rarity : int = 0
var selected_type : int = 0

func filter_packs(_index : int) -> void:
	selected_rarity = rarity_filter.get_selected_id()
	selected_type = type_filter.get_selected_id()
	for pack in pack_container.get_children():
		var rarity_good : bool = (selected_rarity == 0 or pack._metadata.rarity == rarity_filter.get_item_text(selected_rarity))
		var type_good : bool = (selected_type == 0 or pack._metadata.type == type_filter.get_item_text(selected_type))
		pack.visible = rarity_good and type_good
