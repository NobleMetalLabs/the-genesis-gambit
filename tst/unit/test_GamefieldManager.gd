extends GutTest

class TestGamefieldStateHandling:
	extends GutTest

	var gamefield_scn_res : PackedScene = preload("res://scn/Gamefield.tscn")
	var gamefield : Node2D = null

	func before_each() -> void:
		gamefield = gamefield_scn_res.instantiate()
		self.add_child(gamefield)

	func after_each() -> void:
		gamefield.free()
	
	func test_export_empty() -> void:
		pass

class TestGamefieldCardManipulation:
	extends GutTest

	func test_place_card() -> void:
		pass

class TestGamefieldEventProcessing:
	extends GutTest

	func test_process_event_single() -> void:
		pass

	func test_process_event_multiple() -> void:
		pass

	func test_process_event_frozen() -> void:
		pass