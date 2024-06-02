class_name EffectQueueViewer
extends Window


@onready var gamefield : Gamefield = get_tree().get_root().find_child("GAMEFIELD", true, false)
@onready var tree : Tree = $"%TREE"
@onready var effect_resolver : EffectResolver = gamefield.effect_resolver

func _ready() -> void:
	tree.set_column_title(0, "Effect by Requester")
	tree.set_column_expand(0, true)
	tree.set_column_expand_ratio(0, 3)
	tree.set_column_title(1, "Status")
	tree.set_column_expand(1, true)
	tree.set_column_expand_ratio(1, 1)
	tree.set_column_title(2, "Meta")
	tree.set_column_expand(2, true)
	tree.set_column_expand_ratio(2, 3)

var _object_to_treeitem : Dictionary = {} #[Object, TreeItem]

func _process(_delta : float) -> void:
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
	for card : ICardInstance in GamefieldState.new(gamefield.players).cards:
		var card_item : TreeItem = tree.create_item(cards_parent)
		card_item.set_text(0, str(card))
		_object_to_treeitem[card] = card_item
	
	# assign effects in queue / just removed (to show them as done)
	for effect : Effect in effect_resolver.effect_queue + effect_resolver._effects_processed_this_frame:
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
		setup_row(effect_item, effect, is_orphan, requester)

func setup_row(item : TreeItem, effect : Effect, is_orphan : bool, requester : Object) -> void:
	item.set_text(0, str(effect))
	if effect in effect_resolver._effects_requested_this_frame:
		item.set_text(1, "NEW")
	if effect in effect_resolver._effects_processed_this_frame:
		item.set_text(1, "DONE")
	if is_orphan:
		item.set_text(1, "ORPHAN")
		if requester:
			item.set_text(2, str(requester).get_slice("(", 0))
		else:
			item.set_text(2, "<Freed Object>")