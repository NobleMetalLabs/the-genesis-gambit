class_name CooldownEffect
extends Effect

var obj_stats : IStatisticPossessor
var type : Genesis.CooldownType
var frames : int = 0
var total_frames : int = 0
var callback : Callable = Callable()

func _init(_requester : Object, _obj_stats : IStatisticPossessor, _type : Genesis.CooldownType, _frames : int, _callback : Callable = Callable(), _total_frames : int = -1) -> void:
	self.requester = _requester
	self.obj_stats = _obj_stats
	self.type = _type
	self.frames = _frames
	self.callback = _callback
	if _total_frames < 0: self.total_frames = _frames
	else: self.total_frames = _total_frames

func _to_string() -> String:
	return "CooldownEffect(%s,%s,%s,%s)" % [self.obj_stats, self.type, self.frames, self.callback]

func resolve(_effect_resolver : EffectResolver) -> void:
	var cooldowns : Array = obj_stats.get_statistic(Genesis.Statistic.CURRENT_COOLDOWNS).duplicate()
	
	for cooldown : CooldownEffect in cooldowns:
		if cooldown.type == self.type: cooldowns.erase(cooldown)
	
	if frames == 0:
		if self.callback.is_valid():
			self.callback.call()
	else:
		_effect_resolver.request_effect(CooldownEffect.new(
			self.requester,
			self.obj_stats,
			self.type,
			self.frames - 1,
			self.callback,
			self.total_frames
		))
		cooldowns.append(self)
	
	obj_stats.set_statistic(Genesis.Statistic.CURRENT_COOLDOWNS, cooldowns)
