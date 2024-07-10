#class_name AuthoritySourceProvider
extends Node

var authority_source : AuthoritySource = lockstep()

func dummy() -> AuthoritySource:
	var _dummy := DummyAuthoritySource.new()
	self.add_child(_dummy)
	return _dummy

func lockstep() -> AuthoritySource:
	var _lockstep := LockstepMultiplayerAuthoritySource.new()
	self.add_child(_lockstep)
	return _lockstep