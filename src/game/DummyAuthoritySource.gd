class_name DummyAuthoritySource
extends AuthoritySource

var action_queue : Array[Action] = []

func _process(_delta : float) -> void:
	for action in action_queue:
		print("Executing action: %s" % action)
		reflect_action.emit(action)
	action_queue.clear()

func request_action(action : Action) -> void:
	action_queue.push_back(action)
	#print("Queued action: %s" % action)

	
	