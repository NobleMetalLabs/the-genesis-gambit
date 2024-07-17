class_name NetworkMatch
extends RefCounted

signal dispatch_draft_stage(config : NetworkDraftStageConfiguration)
signal dispatch_play_stage(config : NetworkPlayStageConfiguration)

var match_config : NetworkMatchConfiguration

func _init(_config : NetworkMatchConfiguration) -> void:
	self.match_config = _config

func start_match() -> void:
	#dispatch_draft_stage.emit(NetworkDraftStageConfiguration.setup(self.match_config.players))
	#draft_stage.completed.connect(_submit_draft_results)

	var dr : Dictionary = {}
	for np in match_config.players:
		dr[np.peer_id] = Deck.prebuilt_from_tribe(Genesis.CardTribe.BUGS)
	_submit_draft_results(dr)

func _submit_draft_results(decks_by_player_uid : Dictionary) -> void: #[int, Deck]
	var psc := NetworkPlayStageConfiguration.setup(self.match_config.players, decks_by_player_uid)
	dispatch_play_stage.emit(psc)
