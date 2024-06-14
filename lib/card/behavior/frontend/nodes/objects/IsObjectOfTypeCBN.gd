class_name IsObjectOfTypeCBN
extends CardBehaviorNode

func _init() -> void:
	super("IsObjectOfType",
		[
			CardBehaviorArgument.object("object"),
			CardBehaviorArgument.string_name_options("type",
				[
					#Effects
					"ApplyMoodEffect",
					"CreatureActivateEffect",
					"CreatureAttackEffect",
					"CreatureCooldownEffect",
					"CreatureLeavePlayEffect",
					"CreatureSpawnEffect",
					"CreatureTargetEffect",
					"DeckAddCardEffect",
					"DecKRemoveCardEffect",
					"HandAddCardEffect",
					"HandBurnHandEffect",
					"HandRemoveCardEffect",
					"ModifyStatisticEffect",
					"RemoveMoodEffect",
					"SetStatisticEffect",
					#Gameobjects
					"Card",
					"Targetable",
					"Player",
				]
			)
		],  
		[
			CardBehaviorArgument.bool("result")
		]
	)
