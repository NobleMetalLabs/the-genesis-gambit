class_name CreatureCooldownAction

var type : CooldownType
enum CooldownType {
	ATTACK,
	ACTIVATE,
}
var stage : CooldownStage
enum CooldownStage {
	START,
	FINISH,
}
var time : int = 0