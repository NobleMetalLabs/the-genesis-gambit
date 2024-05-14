class_name DummyAuthoritySource
extends AuthoritySource

func request_action(action : Dictionary) -> void:
	print(action)
	self.reflect_action.emit(action)
