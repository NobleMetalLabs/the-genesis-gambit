class_name CardBorderComponent
extends Control

@export var common_texture : Texture2D
@export var rare_texture : Texture2D
@export var mythic_texture : Texture2D
@export var epic_texture : Texture2D

@onready var texture_rect : TextureRect = $TextureRect

func set_rarity(rarity : String) -> void:
	var rarity_to_texture : Dictionary = {
		"Common" : common_texture,
		"Rare" : rare_texture,
		"Mythic" : mythic_texture,
		"Epic" : epic_texture
	}
	texture_rect.texture = rarity_to_texture[rarity]
