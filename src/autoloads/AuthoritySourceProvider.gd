#class_name AuthoritySourceProvider
extends Node

var authority_source : AuthoritySource = lockstep()

func dummy() -> AuthoritySource:
	var dummy := DummyAuthoritySource.new()
	self.add_child(dummy)
	return dummy

func lockstep() -> AuthoritySource:
	var lockstep := LockstepMultiplayerAuthoritySource.new()
	self.add_child(lockstep)
	return lockstep