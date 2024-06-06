class_name CreatureSpawnAction
extends GamefieldAction

var card : ICardInstance
var keep_stats : bool
var keep_moods : bool

func _init(_card : ICardInstance, _keep_stats : bool = true, _keep_moods : bool = true) -> void:
	self.card = _card
	self.keep_stats = _keep_stats
	self.keep_moods = _keep_moods

func _to_string() -> String:
	return "CreatureSpawnAction(%s,%s)" % [self.creature, self.position]

func to_effect() -> CreatureSpawnEffect:
	return CreatureSpawnEffect.new(card, keep_stats, keep_moods)