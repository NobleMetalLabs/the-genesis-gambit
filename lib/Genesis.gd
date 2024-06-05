class_name Genesis
extends Object

## Genesis is a class that provides objects needed in a global scope for the game. This is mostly data-related enums and constants.

# Actions and Events

# CreatureCooldown*
enum CooldownType {
	ATTACK,
	ACTIVATE,
}
enum CooldownStage {
	START,
	IN_PROGRESS,
	FINISH,
}

# CreatureLeavePlay*
enum LeavePlayReason {
	DIED,
	BANISHED,
	SACRIFICED,
}

# HandRemoveCard*
enum LeaveReason {
	PLAYED,
	DISCARDED,
	BANISHED,
}
enum CardRemoveAnimation {
	PLAY,
	DISCARD,
	BURN,
	BANISH,
}

# Statistics

enum Statistic {
	# Basic
	HEALTH,
	STRENGTH,
	SPEED,
	CHARGES,
	# State
	WAS_JUST_PLAYED,
	JUST_ATTACKED,
	WAS_JUST_ATTACKED,
	WAS_JUST_ACTIVATED,
	JUST_STARTED_COOLDOWN,
	IS_IN_COOLDOWN,
	JUST_FINISHED_COOLDOWN,
	JUST_TARGETED,
	WAS_JUST_TARGETED,
	JUST_DIED,
	WAS_JUST_SACRIFICED,
	WAS_JUST_DESTROYED,
	HAS_TARGET,
	IS_IN_HAND,
	IS_ON_FIELD,
	IS_IN_DECK,
	IS_MARKED,
	WAS_JUST_MARKED,
	WAS_JUST_UNMARKED,
	# References
	TARGET,
	# Ability
	CAN_ATTACK,
	CAN_BE_ATTACKED,
	CAN_BE_ACTIVATED,
	CAN_TARGET,
	CAN_BE_TARGETED,
	CAN_BE_SACRIFICED,
	CAN_BE_DESTROYED,
	# Counts
	NUM_ATTACKS_MADE,
	NUM_ATTACKS_RECIEVED,
	NUM_ACTIVATIONS,
	NUM_MOODS,
	NUM_MOOD_CHANGES,
	NUM_COOLDOWN_FRAMES_REMAINING,
	# Player
	MAX_HAND_SIZE,
	MAX_ENERGY,
	NUM_INSTANTS_PLAYED,
	NUM_CREATURES_PLAYED,
	NUM_SUPPORTS_PLAYED,
	NUM_CARDS_PLAYED,
	NUM_CARDS_DRAWN,
	NUM_CARDS_BURNED,
	NUM_CARDS_MARKED,
	NUM_CARDS_LEFT_IN_DECK,
}

const STATISTIC_DEFAULTS : Dictionary = { #[Statistic, Variant]
	# Basic
	Statistic.HEALTH : 10,
	Statistic.STRENGTH : 10,
	Statistic.SPEED : 10,
	Statistic.CHARGES : 0,
	# State
	Statistic.WAS_JUST_PLAYED : false,
	Statistic.JUST_ATTACKED : false,
	Statistic.WAS_JUST_ATTACKED : false,
	Statistic.WAS_JUST_ACTIVATED : false,
	Statistic.JUST_STARTED_COOLDOWN : false,
	Statistic.IS_IN_COOLDOWN : false,
	Statistic.JUST_FINISHED_COOLDOWN : false,
	Statistic.JUST_TARGETED : false,
	Statistic.WAS_JUST_TARGETED : false,
	Statistic.JUST_DIED : false,
	Statistic.WAS_JUST_SACRIFICED : false,
	Statistic.WAS_JUST_DESTROYED : false,
	Statistic.HAS_TARGET : false,
	Statistic.IS_IN_HAND : false,
	Statistic.IS_ON_FIELD : false,
	Statistic.IS_IN_DECK : false,
	Statistic.IS_MARKED : false,
	Statistic.WAS_JUST_MARKED : false,
	Statistic.WAS_JUST_UNMARKED : false,
	# References
	Statistic.TARGET : null,
	# Ability
	Statistic.CAN_ATTACK : true,
	Statistic.CAN_BE_ATTACKED : true,
	Statistic.CAN_BE_ACTIVATED : true,
	Statistic.CAN_TARGET : true,
	Statistic.CAN_BE_TARGETED : true,
	Statistic.CAN_BE_SACRIFICED : true,
	Statistic.CAN_BE_DESTROYED : true,
	# Counts
	Statistic.NUM_ATTACKS_MADE : 0,
	Statistic.NUM_ATTACKS_RECIEVED : 0,
	Statistic.NUM_ACTIVATIONS : 0,
	Statistic.NUM_MOODS : 0,
	Statistic.NUM_MOOD_CHANGES : 0,
	Statistic.NUM_COOLDOWN_FRAMES_REMAINING : 0,
	# Player
	Statistic.MAX_HAND_SIZE : 10,
	Statistic.MAX_ENERGY : 10,
	Statistic.NUM_INSTANTS_PLAYED: 10,
	Statistic.NUM_CREATURES_PLAYED: 0,
	Statistic.NUM_SUPPORTS_PLAYED: 0,
	Statistic.NUM_CARDS_PLAYED: 0,
	Statistic.NUM_CARDS_DRAWN: 0,
	Statistic.NUM_CARDS_BURNED: 0,
	Statistic.NUM_CARDS_MARKED: 0,
	Statistic.NUM_CARDS_LEFT_IN_DECK: 0,
}