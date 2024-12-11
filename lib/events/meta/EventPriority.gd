class_name EventPriority
extends RefCounted

var stage : int = PROCESSING_STAGE.EVENT
enum PROCESSING_STAGE {
	PREPREEVENT = 7,
	PREEVENT = 6,
	EVENT = 5,
	POSTEVENT = 4,
	POSTPOSTEVENT = 3,
}

var rarity : int = PROCESSING_RARITY.COMMON
enum PROCESSING_RARITY {
	LEADER = 7,
	EPIC = 6,
	MYTHIC = 5,
	RARE = 4,
	COMMON = 3,
}

const PROCESSING_INDIVIDUAL_BASE : int = 50
const PROCESSING_INDIVIDUAL_MIN : int = 0
const PROCESSING_INDIVIDUAL_MAX : int = 99
var individual : int = PROCESSING_INDIVIDUAL_BASE

func _init() -> void: return

func DEFINE(processing_stage : int, processing_rarity : int, processing_individual : int) -> EventPriority:
	self.stage = processing_stage
	self.rarity = processing_rarity
	self.individual = processing_individual
	return self

func STAGE(processing_stage : int) -> EventPriority:
	self.stage = processing_stage
	return self

func RARITY(processing_rarity : int) -> EventPriority:
	self.rarity = processing_rarity
	return self

func RARITY_FROM_CARD(card : ICardInstance) -> EventPriority:
	self.rarity = PROCESSING_RARITY.COMMON + card.metadata.rarity
	return self

func INDIVIDUAL(processing_individual : int) -> EventPriority:
	self.individual = processing_individual
	return self

func to_int() -> int:
	return self.stage * 1000 + (10 * self.individual) + self.rarity
