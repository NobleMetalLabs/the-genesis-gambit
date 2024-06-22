#class_name Router
extends Node

@onready var gamefield : Gamefield = get_tree().get_root().find_child("GAMEFIELD", true, false)
@onready var client_ui : ClientUI = get_tree().get_root().find_child("CLIENT-UI", true, false)
