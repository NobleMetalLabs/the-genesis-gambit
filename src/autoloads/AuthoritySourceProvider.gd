#class_name AuthoritySourceProvider
extends Node

var provider : AuthoritySource = make_authority_source()

func make_authority_source() -> AuthoritySource:
	var dummy := DummyAuthoritySource.new()
	self.add_child(dummy)
	return dummy