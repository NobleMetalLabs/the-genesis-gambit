extends CardLogic

func _init() -> void:
	super({
		"on_placement" : print_funny_to_console
	})

func print_funny_to_console(data : Dictionary) -> void:
	print("Funny")