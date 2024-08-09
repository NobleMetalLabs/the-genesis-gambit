class_name NetworkMatch
extends RefCounted

signal dispatch_draft_stage(config : NetworkDraftStageConfiguration)
signal dispatch_play_stage(config : NetworkPlayStageConfiguration)

var match_config : NetworkMatchConfiguration

func _init(_config : NetworkMatchConfiguration) -> void:
	self.match_config = _config

func start_match(config : NetworkPlayStageConfiguration) -> void:
	dispatch_play_stage.emit(config)
