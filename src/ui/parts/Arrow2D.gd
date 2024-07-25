class_name Arrow2D
extends Line2D

@export var arrowhead_sprite : Texture2D = preload("res://ast/ui/image/arrowheadfull.png")
var _arrowhead : Sprite2D

var start_position : Vector2 : 
	set(value):
		self.position = value
	get:
		return self.get_point_position(0)

var end_position : Vector2 : 
	set(value):
		var local : Vector2 = self.to_local(value)
		self.set_point_position(1, local)
		var half_head_height : float = 0.5 * _arrowhead.texture.get_height()
		var _end_position : Vector2 = local.normalized() * (local.length() - Vector2(half_head_height, half_head_height).length())
		_arrowhead.position = _end_position
		_arrowhead.rotation = local.angle() - deg_to_rad(135)
	get:
		return self.get_point_position(1)

func _init() -> void:
	self.add_point(Vector2(0, 0))
	self.add_point(Vector2(0, 0))
	self.end_cap_mode = LINE_CAP_BOX
	self.width = 2
	self.antialiased = true

	_arrowhead = Sprite2D.new()
	_arrowhead.texture = arrowhead_sprite
	self.add_child(_arrowhead)
