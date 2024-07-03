class_name EffectResolverViewer
extends Window

@onready var tree : Tree = $"%TREE"

func _ready() -> void:
	self.close_requested.connect(self.hide)

	self.position = DisplayServer.window_get_position() + Vector2i(10, 40)

	tree.set_column_title(0, "Effect by Requester")
	tree.set_column_expand(0, true)
	tree.set_column_expand_ratio(0, 3)
	tree.set_column_title(1, "Status")
	tree.set_column_expand(1, true)
	tree.set_column_expand_ratio(1, 1)
	tree.set_column_title(2, "Location")
	tree.set_column_expand(2, true)
	tree.set_column_expand_ratio(2, 1)
	tree.set_column_title(3, "Meta")
	tree.set_column_expand(3, true)
	tree.set_column_expand_ratio(3, 3)

var _object_to_treeitem : Dictionary = {} #[Object, TreeItem]

func _process(_delta : float) -> void:
	if not self.visible: return
	tree.clear()
	_object_to_treeitem.clear()
	var root : TreeItem = tree.create_item(null)

	var orphans_parent : TreeItem = tree.create_item(root)
	orphans_parent.set_text(0, "Orphans")

	# tally actions
	var actions_parent : TreeItem = tree.create_item(root)
	actions_parent.set_text(0, "Actions")
	for action : Action in AuthoritySourceProvider.authority_source.action_queue:
		var action_item : TreeItem = tree.create_item(actions_parent)
		action_item.set_text(0, str(action))
		_object_to_treeitem[action] = action_item
		
	# tally cards
	var cards_parent : TreeItem = tree.create_item(root)
	cards_parent.set_text(0, "Cards")
	for card : ICardInstance in Router.gamefield.get_gamefield_state().cards:
		var card_item : TreeItem = tree.create_item(cards_parent)
		setup_card_row(card_item, card)
		_object_to_treeitem[card] = card_item
	
	# assign effects in queue / just removed (to show them as done)
	for effect : Effect in Router.gamefield.effect_resolver.effect_list:
		var requester : Object = effect.requester
		var item_parent : TreeItem
		var is_orphan : bool
		if not is_instance_valid(requester):
			requester = null
			is_orphan = true
			item_parent = orphans_parent
		else:
			is_orphan = not _object_to_treeitem.has(requester)
			item_parent = _object_to_treeitem.get(requester, orphans_parent)
		var effect_item : TreeItem = tree.create_item(item_parent)
		effect_item.set_text(0, str(effect))

		_object_to_treeitem[effect] = effect_item
		setup_effect_row(effect_item, effect, is_orphan, requester)

func setup_card_row(item : TreeItem, card : ICardInstance) -> void:
	item.set_text(0, str(card))
	if card == null:
		push_warning("Card is null.")
		return
	var req_stats := IStatisticPossessor.id(card)
	var in_deck : bool = req_stats.get_statistic(Genesis.Statistic.IS_IN_DECK)
	var in_hand : bool = req_stats.get_statistic(Genesis.Statistic.IS_IN_HAND)
	var on_field : bool = req_stats.get_statistic(Genesis.Statistic.IS_ON_FIELD)
	var state_sum : int = (in_deck as int) + (in_hand as int) + (on_field as int)
	if state_sum == 0:
		item.set_text(2, "!!!NONE")
	elif state_sum == 1:
		if in_deck:
			item.set_text(2, "DECK")
		elif in_hand:
			item.set_text(2, "HAND")
		else:
			item.set_text(2, "FIELD")
	else:
		item.set_text(2, "!!!MULTIPLE")


func setup_effect_row(item : TreeItem, effect : Effect, is_orphan : bool, requester : Object) -> void:
	item.set_text(0, str(effect))
	match(effect.resolve_status):
		Effect.ResolveStatus.REQUESTED:
			item.set_text(1, "NEW")
		Effect.ResolveStatus.RESOLVED:
			item.set_text(1, "RESOLVED")
	if is_orphan:
		if requester:
			item.set_text(3, "ORPHAN to " + str(requester).get_slice("(", 0))
		else:
			item.set_text(3, "ORPHAN to <Freed Object>")
