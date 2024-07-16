class_name PlayerAreaUI
extends Panel

var associated_player : Player

@onready var hand_ui : HandUI = $"%HAND-UI"
@onready var field_ui : FieldUI = $"%FIELD-UI"
@onready var cursor : PlayerCursorUI = $"%PLAYER-CURSOR"

var flipped : bool :
	get: return flipped
	set(value): 
		flipped = value
		hand_ui.get_parent().set_anchors_preset(PRESET_CENTER_TOP if flipped else PRESET_CENTER_BOTTOM)
		hand_ui.get_parent().position.y = 0 #I LOVE GODOT ENGINE!!!!

func refresh_ui() -> void:
	hand_ui.refresh_hand()
	field_ui.refresh_field()

	_move_cursor()

func _ready() -> void:
	Router.client_ui.client_ui_setup.connect(_cursor_setup)

func _cursor_setup() -> void:
	var my_id : int = Router.backend.player_to_peer_id[associated_player]
	var my_name : String = MultiplayerManager.peer_id_to_player[my_id].player_name
	cursor.set_player_name(my_name)

	if associated_player == Router.backend.local_player:
		print("%s : PA for local player %s connected to request cursor updates." % [multiplayer.get_unique_id(), associated_player])
		var auth_source : AuthoritySource = AuthoritySourceProvider.authority_source
		auth_source.new_frame_index.connect(
			func request_cursor_motion_action(_frame_number : int) -> void:
				auth_source.request_action(
					CursorMotionAction.setup(Router.client_ui.get_local_mouse_position())
				)
		)

func _move_cursor() -> void:
	var cursor_pos : Vector2 = IStatisticPossessor.id(associated_player).get_statistic(Genesis.Statistic.POSITION)
	var local_pos := cursor_pos - self.position
	if flipped:
		local_pos = Router.client_ui.size - local_pos
	cursor.position = local_pos