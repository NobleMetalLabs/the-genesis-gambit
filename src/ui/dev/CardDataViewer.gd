class_name CardDataViewer
extends Control

@onready var moods_holder : VBoxContainer = $"%MOODS-HOLDER"
@onready var stats_holder : VBoxContainer = $"%STATS-HOLDER"

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
	var card_stats := IStatisticPossessor.id(card)
	if card_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD):
		$"%location-label".text = "Location: <On Field>"
	elif card_stats.get_statistic(Genesis.Statistic.IS_IN_HAND):
		$"%location-label".text = "Location: <In Hand>"
	elif card_stats.get_statistic(Genesis.Statistic.IS_IN_DECK):
		$"%location-label".text = "Location: <In Deck>"
	$"%player-label".text = "Player: <%s>" % card.player.name

	for mood in IMoodPossessor.id(card)._active_moods:
		var mood_label := Label.new()
		mood_label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		mood_label.custom_minimum_size = Vector2.ONE
		mood_label.text = str(mood)
		moods_holder.add_child(mood_label)

	var stats := IStatisticPossessor.id(card)
	var stat_db : Dictionary = stats._statistic_db
	for stat : Genesis.Statistic in stat_db.keys():
		var stat_label := Label.new()
		stat_label.autowrap_mode = TextServer.AUTOWRAP_ARBITRARY
		stat_label.custom_minimum_size = Vector2.ONE
		stat_label.text = "'%s' = %s" % [Genesis.Statistic.keys()[stat], stats.get_statistic(stat)]
		stats_holder.add_child(stat_label)
