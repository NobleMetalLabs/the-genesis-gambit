class_name MultiplayerPanel
extends Panel

signal host_game()
signal join_game()

func _ready() -> void:
	var button_stack : VBoxContainer = get_node("ButtonStack")
	var host_button : Button = button_stack.get_node("HostButton")
	var join_button : Button = button_stack.get_node("JoinButton")
	host_button.pressed.connect(
		func() -> void: 
			host_game.emit()
			self.hide()
	)
	join_button.pressed.connect(
		func() -> void: 
			join_game.emit()
			self.hide()
	)

