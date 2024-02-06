extends PopupPanel

@export var card_scene : PackedScene
@onready var pool_container : HBoxContainer = $"%POOL-CONTAINER"

func show_with_metadata(metadata : PackMetadata) -> void:
	title = metadata.name + " Pool"
	var card_pool : Array = metadata.card_pool
	for card_with_prob : CardWithProbability in card_pool:
		var new_card_data : CardMetadata = card_with_prob.card
		var new_card : UIFullCard = card_scene.instantiate()
		
		pool_container.add_child(new_card, true)
		new_card.set_metadata(new_card_data)
		new_card.custom_minimum_size = Vector2(260,340)
