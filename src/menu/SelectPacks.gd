extends Node

@export var cardpack_path : String = "res://ast/game/cardpacks/data"
@export var pack_scene : PackedScene
@export var pack_slice_scene : PackedScene
@onready var pack_container : GridContainer = $"%GRID-CONTAINER"
@onready var rarity_filter : OptionButton = $"%RARITY-FILTER"
@onready var type_filter : OptionButton = $"%TYPE-FILTER"
@onready var slice_container : VBoxContainer = $"%SLICE-CONTAINER"

var deck : DeckData = SaveData.selected_deck

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
		new_pack.full_button.pressed.connect(add_slice.bind(new_pack_data))

func filter_packs(_index : int) -> void:
	var selected_rarity : int = rarity_filter.selected
	var selected_type : int = type_filter.selected
	for pack : UIFullPack in pack_container.get_children():
		var rarity_good : bool = (selected_rarity == 0 or pack._metadata.rarity == rarity_filter.get_item_text(selected_rarity))
		var type_good : bool = (selected_type == 0 or pack._metadata.type == type_filter.get_item_text(selected_type))
		pack.visible = rarity_good and type_good

func update_pack_slices(_deck: DeckData) -> void:
	for slice : UIPackSlice in slice_container.get_children(): slice.queue_free()
	
	var pack_counts : Dictionary # [PackMetadata, int]
	for pack : PackMetadata in _deck.get_contents():
		if pack_counts.has(pack): pack_counts[pack] += 1
		else: pack_counts[pack] = 1
	
	for unique_pack : PackMetadata in pack_counts.keys():
		var new_slice : UIPackSlice = pack_slice_scene.instantiate()
		slice_container.add_child(new_slice, true)
		
		new_slice.set_metadata(unique_pack)
		new_slice.set_label_multiplier(pack_counts[unique_pack])
		new_slice.full_button.pressed.connect(remove_slice.bind(unique_pack))

func add_slice(_metadata : PackMetadata) -> void:
	deck.add_pack(_metadata)
	update_pack_slices(deck)

func remove_slice(_metadata : PackMetadata) -> void:
	deck.remove_pack(_metadata)
	update_pack_slices(deck)
