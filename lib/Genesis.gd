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
	FINISH,
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
	JUST_FINISHED_COOLDOWN,
	JUST_TARGETED,
	WAS_JUST_TARGETED,
	JUST_DIED,
	WAS_JUST_SACRIFICED,
	WAS_JUST_DESTROYED,
	HAS_TARGET,
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