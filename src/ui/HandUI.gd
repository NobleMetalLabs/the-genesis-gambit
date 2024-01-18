class_name HandUI
extends Control

var client_ui : ClientUI
var player_owner : Player

@onready var card_stack_container : HBoxContainer = $"CardStack"

func _setup(_client_ui : ClientUI, _player_owner : Player) -> void:
	client_ui = _client_ui
	player_owner = _player_owner
	player_owner.hand_updated.connect(_handle_hand_update)

func _handle_hand_update(data : Dictionary) -> void:
	var event_type : String = data["type"]
	match event_type:
		"add":
			_add_card_to_hand(data["metadata"])
		"remove":
			_remove_card_from_hand(data["instance"])
		"clear":
			_clear_hand()

var hovered_hand_card : CardInstanceInHand = null

func _add_card_to_hand(metadata : CardMetadata) -> void:
	var new_hand_card : CardInstanceInHand = ObjectDB._CardInstanceInHand.create(metadata)
	card_stack_container.add_child(new_hand_card, true)
	new_hand_card.mouse_entered.connect(
		func() -> void:
			hovered_hand_card = new_hand_card
	)
	new_hand_card.mouse_exited.connect(
		func() -> void:
			hovered_hand_card = null
	)

func _remove_card_from_hand(_instance : CardInstanceInHand) -> void:
	_instance.queue_free()

func _clear_hand() -> void:
	for child in card_stack_container.get_children():
		child.queue_free()

