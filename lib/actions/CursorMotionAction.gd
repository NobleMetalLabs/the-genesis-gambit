class_name CursorMotionAction
extends CursorAction

var position : Vector2

static func setup(_position : Vector2) -> CursorMotionAction:
	var cma := CursorMotionAction.new()
	cma.position = _position
	return cma

func _init() -> void: pass

func _to_string() -> String:
	return "CursorMotionAction(%s)" % [self.position]

func to_effect() -> SetStatisticEffect:
	return SetStatisticEffect.new(self, IStatisticPossessor.id(Router.backend.peer_id_to_player[player_peer_id]), Genesis.Statistic.POSITION, position)