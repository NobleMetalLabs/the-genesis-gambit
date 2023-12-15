class_name Gamefield
extends Node2D

signal event(name : StringName, data : Dictionary)

@onready var manager : GamefieldManager = get_node("GamefieldManager")
@onready var cards_parent : Node2D = get_node("Cards")
