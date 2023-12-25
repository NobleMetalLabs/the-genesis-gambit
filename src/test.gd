class_name Test
extends Node

@export var meta : CardMetadata = null
@onready var hui : HandUI = get_parent()

var did : bool = false
func _process(_delta : float) -> void:
	if did: return
	hui._handle_hand_update({
		"type" : "add",
		"metadata" : meta
	})
	did = true
