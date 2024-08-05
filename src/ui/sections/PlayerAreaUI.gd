class_name PlayerAreaUI
extends Panel

var associated_player : Player

@onready var hand_ui : HandUI = $"%HAND-UI"
@onready var field_ui : FieldUI = $"%FIELD-UI"
@onready var deck_ui : DeckUI = $"%DECK-UI"
@onready var cursor : PlayerCursorUI = $"%PLAYER-CURSOR"

var flipped : bool :
	get: return flipped
	set(value): 
		flipped = value
		hand_ui.get_parent().set_anchors_preset(PRESET_CENTER_TOP if flipped else PRESET_CENTER_BOTTOM)
		hand_ui.get_parent().position.y = 0 #I LOVE GODOT ENGINE!!!!
		hand_ui.energy_bar.fill_mode = (ProgressBar.FILL_TOP_TO_BOTTOM if flipped else ProgressBar.FILL_BOTTOM_TO_TOP)
		deck_ui.set_flipped(flipped)

func force_refresh_ui() -> void:
	hand_ui.force_refresh_ui()
	field_ui.force_refresh_ui()
	deck_ui.force_refresh_ui()

func _process(_delta : float) -> void:
	_move_cursor()

func _ready() -> void:
	Router.client_ui.client_ui_setup.connect(_cursor_setup)

func _cursor_setup() -> void:
	var my_id : int = Router.backend.player_to_peer_id[associated_player]
	var my_name : String = MultiplayerManager.peer_id_to_player[my_id].player_name
	cursor.set_player_name(my_name)

	if associated_player == Router.backend.local_player:
		var auth_source : AuthoritySource = AuthoritySourceProvider.authority_source
		auth_source.new_frame_index.connect(
			func request_cursor_motion_action(_frame_number : int) -> void:
				auth_source.request_action(
					CursorMotionAction.setup(Router.client_ui.get_local_mouse_position())
				)
		)

var cursor_points : Array[Vector2] = [Vector2.ZERO, Vector2.ZERO, Vector2.ZERO]
var curve_traverse : float = 0
func _move_cursor() -> void:
	if associated_player == Router.backend.local_player:
		cursor.visible = false
		return
	var cursor_pos : Vector2 = IStatisticPossessor.id(associated_player).get_statistic(Genesis.Statistic.POSITION)
	var local_pos := cursor_pos - self.position
	if flipped:
		local_pos = Vector2(local_pos.x, Router.client_ui.size.y - local_pos.y)
	
	if not cursor_points[0].is_equal_approx(local_pos):
		cursor_points.push_front(local_pos)
		cursor_points.pop_back()
		curve_traverse = 0
	else:
		curve_traverse = move_toward(curve_traverse, 1, 0.1)

	var curve_points : Array[Vector2] = _get_path_with_influence(cursor_points[1], cursor_points[0], cursor_points[2])
	var curve : Curve2D = Curve2D.new()
	curve.add_point(curve_points[0], Vector2.ZERO, curve_points[1])
	curve.add_point(curve_points[3], curve_points[2], Vector2.ZERO)
	
	var curve_position : Vector2 = curve.sample_baked(curve_traverse * curve.get_baked_length(), true)
	cursor.position = cursor.position.move_toward(curve_position, 100)
	#cursor.position = local_pos

func _get_path_with_influence(start : Vector2, end : Vector2, influence : Vector2) -> Array[Vector2]:
	return [
		start,
		-(influence - start) / 2,
		-(end - start) / 2,
		end,
	]
