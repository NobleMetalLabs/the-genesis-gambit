extends GutTest

var test_sandbox : Sandbox

func before_each() -> void:
	CommandServer.argument_graph = ArgumentGraph.new()
	UIDDB.clear()
	test_sandbox = Sandbox.new()

func after_each() -> void:
	test_sandbox._teardown()
	test_sandbox.free()
	get_tree().get_root().print_orphan_nodes()

func test_r() -> void:
	pass_test("gbioeur")
