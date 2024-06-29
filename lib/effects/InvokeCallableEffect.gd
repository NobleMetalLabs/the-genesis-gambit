class_name InvokeCallableEffect
extends Effect

var callable : Callable
var args : Array[Variant]

func _init(_callable : Callable, _args : Array[Variant] = []) -> void:
	self.callable = _callable
	self.args = _args

func _to_string() -> String:
	return "InvokeCallableEffect(%s, %s)" % [callable, args]

func resolve(_effect_resolver : EffectResolver) -> void:
	callable.callv(args)