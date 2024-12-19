class_name SandboxMenu
extends Control

var sandbox : Sandbox

func _ready() -> void: 
	reset_sandbox()
	AUTO_EXEC()
	
	$"%ResetButton".pressed.connect(reset_sandbox)
	$"%GameTickSpinBox".value_changed.connect(update_data)

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("debug_advance_frame"):
		sandbox.game_access_manager.advance_gametick()
		update_data()
		$"%GameTickSpinBox".value = sandbox.game_access_manager._current_gametick

func reset_sandbox() -> void:
	if sandbox != null: sandbox._teardown()
	
	CommandServer.argument_graph = ArgumentGraph.new()
	UIDDB.clear()
	
	sandbox = Sandbox.new()
	sandbox.game_access_manager.advanced_to_new_gametick.connect(update_data)
	

func update_data(gametick : int = -1) -> void:
	var ticks : Array = sandbox.game_access_manager._game_access_by_gametick.keys()
	$"%GameTickSpinBox".max_value = ticks.max()
	$"%GameTickSpinBox".min_value = ticks.min()

	var game_access : GameAccess = sandbox.game_access_manager.get_current_game_access()
	
	if gametick != -1:
		game_access = sandbox.game_access_manager._game_access_by_gametick[gametick]
	$"%CardsTree".display_cards(game_access._cards)
	$"%EventsTree".display_event_history(game_access.card_processor.event_history)


func AUTO_EXEC() -> void:
	CommandServer.run_command("card spawn moth 1")
	CommandServer.run_command("card act 1 event attacked-event 1 10")
