class_name DummyAuthoritySource
extends AuthoritySource

func request_action(action : Dictionary) -> void:
	self.reflect_action.emit(action)
