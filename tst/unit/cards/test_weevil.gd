extends GutTest

var test_sandbox : Sandbox

func before_each() -> void:
	CommandServer.argument_graph = ArgumentGraph.new()
	UIDDB.clear()
	test_sandbox = Sandbox.new()
	CommandServer.run_command("card spawn weevil 1")

func after_each() -> void:
	test_sandbox._teardown()
	test_sandbox.free()
	get_tree().get_root().print_orphan_nodes()

func test_spawn() -> void:
	assert_eq(test_sandbox.cards_holder.get_children().size(), 1)

func test_buddy() -> void:
	CommandServer.run_command("card act 1 event entered-field-event")
	assert_eq(test_sandbox.cards_holder.get_children().size(), 2)
	
	CommandServer.run_command("card act 2 event entered-field-event")
	assert_eq(test_sandbox.cards_holder.get_children().size(), 2)
	
