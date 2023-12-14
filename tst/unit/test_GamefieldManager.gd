extends GutTest

class TestGamefieldStateHandling:
	extends GutTest

	var gamefield_scn_res = preload("res://scn/Gamefield.tscn")
	var gamefield = null
	func before_each():
		gamefield = gamefield_scn_res.instantiate()
		self.add_child(gamefield)
	func after_each():
		gamefield.free()
	
	func test_export_empty():
		pass

class TestGamefieldCardManipulation:
	extends GutTest

	func test_place_card():
		pass

class TestGamefieldEventProcessing:
	extends GutTest

	func test_process_event_single():
		pass

	func test_process_event_multiple():
		pass

	func test_process_event_frozen():
		pass