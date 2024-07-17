extends Node

func _ready() -> void:
	MultiplayerManager.network_update.connect(func() -> void:
		if MultiplayerManager.peer_id_to_player.keys().size() < 2: return
		if not MultiplayerManager.is_instance_server(): return

		print(UIDDB.object_to_uid.keys())

		var hdca := HandDrawCardAction.setup()
		MultiplayerManager.send_network_message(
			"look at this draw action", [hdca], -1, true
		)
	)
	MultiplayerManager.received_network_message.connect(
		func(_sender : NetworkPlayer, _message : String, args : Array) -> void:
			var deser : HandDrawCardAction = Serializeable.deserialize(args[0])
			print("%s: %s" % [MultiplayerManager.get_peer_id(), deser])
			print("%s: %s" % [MultiplayerManager.get_peer_id(), deser.player])
	)
	

	
