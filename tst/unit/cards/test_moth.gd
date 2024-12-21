extends GutTest

var test_sandbox : Sandbox

func before_each() -> void:
	CommandServer.argument_graph = ArgumentGraph.new()
	UIDDB.clear()
	test_sandbox = Sandbox.new()
	CommandServer.run_command("card spawn moth 1")

func after_each() -> void:
	test_sandbox._teardown()
	test_sandbox.free()
	get_tree().get_root().print_orphan_nodes()

func test_spawn() -> void:
	assert_eq(test_sandbox.game_access_manager.get_current_game_access()._cards.size(), 1)
	

func test_moth_block() -> void:
	CommandServer.run_command("card spawn spider 2")
	CommandServer.run_command("card act 2 event attacked-event 1 1")
	
	var moth_cardinstance := ICardInstance.id(UIDDB.object(1))
	var moth_events = test_sandbox.processor.event_history.get_events_by_card(moth_cardinstance)
	var moth_wasattackedevent : WasAttackedEvent = moth_events.pop_back()

	assert_eq(moth_wasattackedevent.damage, 0)

func test_moth_lethal_block() -> void:
	CommandServer.run_command("card spawn spider 2")
	CommandServer.run_command("card act 2 event attacked-event 1 999")
	
	var moth_cardinstance := ICardInstance.id(UIDDB.object(1))
	var moth_stats := IStatisticPossessor.id(moth_cardinstance)

	
	assert_eq(moth_stats.get_statistic(Genesis.Statistic.IS_IN_DECK), false)

func test_moth_only_blocks_once() -> void:
	CommandServer.run_command("card spawn spider 2")
	CommandServer.run_command("card act 2 event attacked-event 1 999")
	CommandServer.run_command("card act 2 event attacked-event 1 999")
	
	var moth_cardinstance := ICardInstance.id(UIDDB.object(1))
	var moth_stats := IStatisticPossessor.id(moth_cardinstance)

	assert_eq(moth_stats.get_statistic(Genesis.Statistic.IS_IN_DECK), true)
