#class_name Router
extends Node

@onready var backend : MatchBackend = get_tree().get_root().find_child("BACKEND", true, false)
@onready var client_ui : ClientUI = get_tree().get_root().find_child("CLIENT-UI", true, false)
