class_name CardDataViewer
extends Window

@onready var moods_holder : VBoxContainer = $"%MOODS-HOLDER"
@onready var stats_holder : VBoxContainer = $"%STATS-HOLDER"

func _ready() -> void:
	self.close_requested.connect(self.hide)

	self.position = DisplayServer.window_get_position() + \
		Vector2i(0, DisplayServer.window_get_size().y) - \
		Vector2i(0, self.size.y) + \
		Vector2i(10, -10)

var current_card : ICardInstance = null

func set_card(card : ICardInstance) -> void:
	current_card = card

func _process(_delta : float) -> void:
	show_data_for_card(current_card)

func show_data_for_card(card : ICardInstance) -> void:
	$"%meta-label".text = ""
	$"%location-label".text = ""
	$"%player-label".text = ""

	for child in moods_holder.get_children():
		child.queue_free()
	for child in stats_holder.get_children():
		child.queue_free()

	if card == null: return
	
	$"%meta-label".text = "Card: <%s>" % card.metadata.name
	var card_obj : Object = card.get_object()
	if card_obj is CardOnField:
		$"%location-label".text = "Location: <On Field>"
	elif card_obj is CardInHand:
		$"%location-label".text = "Location: <In Hand>"
	elif card_obj is CardInDeck:
		$"%location-label".text = "Location: <In Deck>"
	$"%player-label".text = "Player: <%s>" % card.player.name

	for mood in IMoodPossessor.id(card)._active_moods:
		var mood_label := Label.new()
		mood_label.text = str(mood)
		moods_holder.add_child(mood_label)

	var stat_db : Dictionary = IStatisticPossessor.id(card)._statistic_db
	for stat : Genesis.Statistic in stat_db.keys():
		var stat_label := Label.new()
		stat_label.text = "'%s' = %s" % [Genesis.Statistic.keys()[stat], stat_db[stat]]
		stats_holder.add_child(stat_label)