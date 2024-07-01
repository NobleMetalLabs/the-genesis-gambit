class_name NetworkMatch
extends RefCounted

signal dispatch_draft_stage(config : NetworkDraftStageConfiguration)
signal dispatch_play_stage(config : NetworkPlayStageConfiguration)

var match_config : NetworkMatchConfiguration

func _init(_config : NetworkMatchConfiguration) -> void:
	self.match_config = _config

func start_match() -> void:
	#draft_stage.completed.connect(_submit_draft_results)
	_submit_draft_results({
		0: Deck.prebuilt_from_tribe(Genesis.CardTribe.BUGS),
		1: Deck.prebuilt_from_tribe(Genesis.CardTribe.BUGS),
		2: Deck.prebuilt_from_tribe(Genesis.CardTribe.BUGS),
		3: Deck.prebuilt_from_tribe(Genesis.CardTribe.BUGS),
		4: Deck.prebuilt_from_tribe(Genesis.CardTribe.BUGS), 
		5: Deck.prebuilt_from_tribe(Genesis.CardTribe.BUGS),
	})

func _submit_draft_results(decks_by_player_uid : Dictionary) -> void: #[int, Deck]
	var psc := NetworkPlayStageConfiguration.new(self.match_config.players, decks_by_player_uid)
	dispatch_play_stage.emit(psc)
