extends GutTest

class TestGamefieldStateHandling:
	extends GutTest

	var gamefield_scn_res : PackedScene = preload("res://scn/game/Gamefield.tscn")
	var gamefield : Gamefield = null
	func before_each() -> void:
		gamefield = gamefield_scn_res.instantiate()
		self.add_child(gamefield)

	func after_each() -> void:
		gamefield.free()

	# func test_export_empty() -> void:
	# 	pass

class TestGamefieldCardManipulation:
	extends GutTest

	var gamefield_scn_res : PackedScene = preload("res://scn/game/Gamefield.tscn")
	var gamefield : Gamefield = null
	func before_each() -> void:
		gamefield = gamefield_scn_res.instantiate()
		self.add_child(gamefield)

	func after_each() -> void:
		gamefield.free()

	func test_place_card() -> void:
		var test_metadata : CardMetadata = CardMetadata.new()
		test_metadata.name = "TestCard"
		test_metadata.id = 1

		gamefield.place_card(null, test_metadata, Vector2(0, 0))
		assert_eq(gamefield.cards_holder.get_child_count(), 1)
		var got_meta : CardMetadata = gamefield.cards_holder.get_child(0).metadata
		assert_eq(got_meta.name, test_metadata.name)
		assert_eq(got_meta.id, test_metadata.id)

class TestGamefieldEventProcessing:
	extends GutTest

	# func test_process_event_single() -> void:
	# 	pass

	# func test_process_event_multiple() -> void:
	# 	pass

	# func test_process_event_frozen() -> void:
	# 	pass
