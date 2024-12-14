class_name SandboxMenu
extends Control

var sandbox : Sandbox

func _ready() -> void: 
	reset_sandbox()
	AUTO_EXEC()
	
	$"%ResetButton".pressed.connect(reset_sandbox)

func reset_sandbox() -> void:
	if sandbox != null: sandbox._teardown()
	
	CommandServer.argument_graph = ArgumentGraph.new()
	UIDDB.clear()
	
	sandbox = Sandbox.new()
	$"%CardsTree".set_sandbox(sandbox)
	$"%EventsTree".set_sandbox(sandbox)
	
	add_child(sandbox, true)

func AUTO_EXEC() -> void:
	CommandServer.run_command("card spawn moth 1")
	CommandServer.run_command("card spawn spider 2")
	CommandServer.run_command("card act 2 event attacked-event 1 100")
