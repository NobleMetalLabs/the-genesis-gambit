extends CardLogic

func _init() -> void:
	description = "When played, shift the board in a random direction."
	event_handlers = {
		"on_placement" : print_funny_to_console
	}

func print_funny_to_console(_data : Dictionary) -> void:
	print("Funny")
