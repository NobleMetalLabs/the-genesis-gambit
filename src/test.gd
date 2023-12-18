extends Node

@onready var gm : Gamefield = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gm.event.connect(
		func (name : String, data : Dictionary) -> void:
			if name != "card_placement": return
			foo(data["card_instance"])
	)

func foo(card : CardInstance) -> void:
	var l : Line2D = Line2D.new()
	l.width = 1
	var num_points : float = 2 * (card.get_index() + 1)
	for i in range(0, num_points):
		var ar : float = (i / num_points) * (2 * PI)
		var d : float = card.get_distance_to_edge_at_angle(ar)
		print(d)
		l.add_point(Vector2.from_angle(ar) * d)
	l.closed = true
	l.default_color = Color.RED
	card.add_child(l)