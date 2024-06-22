class_name DummyAuthoritySource
extends AuthoritySource

var action_queue : Array[Action] = []

func request_action(action : Action) -> void:
	action_queue.push_back(action)
	print("Queued action: %s" % action)

	
	