class_name PlayerCursorUI
extends Control

@onready var text : Label = $Label
@onready var cursor : TextureRect = $TextureRect

func set_player_name(player_name : String) -> void:
	text.text = " " + player_name

func cursor_color(color : Color) -> void:
	cursor.modulate = color