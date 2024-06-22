class_name AwaitUIEffect
extends AwaitEffect

var ui_type : Genesis.AwaitUIType

func _init(_requester : Object, _ui_type : Genesis.AwaitUIType) -> void:
	self.requester = _requester
	self.ui_type = _ui_type

func _to_string() -> String:
	return "AwaitUIEffect(%s, %s)" % [self.creature, self.ui_type]

func resolve(_er : EffectResolver) -> void:
	match self.resolve_status:
		Effect.ResolveStatus.REQUESTED:
			# request the ui
			self.resolve_status = Effect.ResolveStatus.AWAITING
		Effect.ResolveStatus.AWAITING:
			# if ui is not ready: return
			# result = get result
			self.resolve_status = Effect.ResolveStatus.RESOLVED