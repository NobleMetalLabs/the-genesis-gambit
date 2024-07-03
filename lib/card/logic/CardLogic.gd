@icon("res://lib/CardLogic.png")
class_name CardLogic
extends RefCounted

var instance_owner : ICardInstance

func _init(_owner : ICardInstance) -> void:
	self.instance_owner = _owner

func process(_gamefield_state : GamefieldState, _effect_resolver : EffectResolver) -> void:
	push_error("CardLogic does not implemented abstract function 'process()'.")