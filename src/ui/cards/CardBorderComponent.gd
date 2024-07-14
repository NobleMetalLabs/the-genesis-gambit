class_name CardBorderComponent
extends Control

@export var common_texture : Texture2D
@export var rare_texture : Texture2D
@export var mythic_texture : Texture2D
@export var epic_texture : Texture2D
@export var leader_texture : Texture2D

@onready var border_texture : TextureRect = $"%BORDER-TEX"
@onready var crown_texture : TextureRect = $"%CROWN-TEX"

func set_rarity(rarity : Genesis.CardRarity) -> void:
	var rarity_to_texture : Dictionary = {
		Genesis.CardRarity.COMMON : common_texture,
		Genesis.CardRarity.RARE : rare_texture,
		Genesis.CardRarity.MYTHIC : mythic_texture,
		Genesis.CardRarity.EPIC : epic_texture,
		Genesis.CardRarity.LEADER : leader_texture,
	}
	border_texture.texture = rarity_to_texture[rarity]
	crown_texture.visible = rarity == Genesis.CardRarity.LEADER
