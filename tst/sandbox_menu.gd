class_name SandboxMenu
extends Control

var sandbox : Sandbox
@onready var game_tick_spinbox : SpinBox = $"%GameTickSpinBox"
const TPS := 30.0

func _ready() -> void: 
	reset_sandbox()
	AUTO_EXEC()
	
	$"%ResetButton".pressed.connect(reset_sandbox)
	game_tick_spinbox.value_changed.connect(sandbox.game_access_manager.revert_to_gametick)
	
	#var tick_timer := Timer.new()
	#tick_timer.timeout.connect(sandbox.game_access_manager.advance_gametick)
	#add_child(tick_timer)
	#tick_timer.start(1 / TPS)
	
	$CommandTerminal.guts.terminal_panel.command_ran.connect(
		func(command : String):
			MultiplayerManager.send_network_message("sandbox-command", [command, sandbox.game_access_manager._current_gametick], -1, true)
			commands_run_by_gametick.get_or_add(sandbox.game_access_manager._current_gametick, [] as Array[String]).append(command)
	)
	
	MultiplayerManager.received_network_message.connect(
		func(_sender : NetworkPlayer, message : String, args : Array):
			match(message):
				"sandbox-command": 
					register_command_at_gametick(args[0], args[1])
	)

var commands_run_by_gametick : Dictionary = {} # {int : Array[String]}
func register_command_at_gametick(new_command : String, gametick : int) -> void:
	commands_run_by_gametick.get_or_add(gametick, [] as Array[String]).append(new_command)
	
	if gametick <= sandbox.game_access_manager._current_gametick:
		var my_gametick : int = sandbox.game_access_manager._current_gametick
		sandbox.game_access_manager.revert_to_gametick(gametick)
		CommandServer.run_command(new_command)
		
		while(sandbox.game_access_manager._current_gametick < my_gametick):
			sandbox.game_access_manager.advance_gametick()
			if not commands_run_by_gametick.has(sandbox.game_access_manager._current_gametick): continue
			for command in commands_run_by_gametick[sandbox.game_access_manager._current_gametick]:
				CommandServer.run_command(command)


func AUTO_EXEC() -> void:
	sandbox.game_access_manager.advance_gametick()
	sandbox.game_access_manager.advance_gametick()
	sandbox.game_access_manager.advance_gametick()
	CommandServer.run_command("card spawn moth 1")
	sandbox.game_access_manager.advance_gametick()
	CommandServer.run_command("card act 1 event entered-field-event")
	sandbox.game_access_manager.advance_gametick()
	CommandServer.run_command("card act 1 event attacked-event 1 10")
	sandbox.game_access_manager.advance_gametick()
	sandbox.game_access_manager.advance_gametick()

func _process(_delta : float) -> void:
	if Input.is_action_just_pressed("debug_advance_frame"):
		sandbox.game_access_manager.advance_gametick()
		
		if commands_run_by_gametick.has(sandbox.game_access_manager._current_gametick):
			for command in commands_run_by_gametick[sandbox.game_access_manager._current_gametick]:
				CommandServer.run_command(command)

func reset_sandbox() -> void:
	if sandbox != null: sandbox._teardown()
	
	CommandServer.argument_graph = ArgumentGraph.new()
	UIDDB.clear()
	
	sandbox = Sandbox.new()
	sandbox.game_access_manager.advanced_to_new_gametick.connect(update_data)

func update_data(gametick : int = -1) -> void:
	game_tick_spinbox.max_value = sandbox.game_access_manager._current_gametick
	game_tick_spinbox.min_value = 0
	game_tick_spinbox.set_value_no_signal(gametick)

	var game_access : GameAccess = sandbox.game_access_manager.game_access
	
	#if gametick != -1:
		#game_access = sandbox.game_access_manager._game_access_by_gametick[gametick]
	$"%CardsTree".display_cards(game_access._cards)
	$"%EventsTree".display_event_history(game_access.event_history)
