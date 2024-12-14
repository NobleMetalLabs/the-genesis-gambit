class_name KillFeedItem
extends RefCounted

var content : String
var child_items : Array[KillFeedItem]

func _init(_content : String, _child_items : Array[KillFeedItem] = []) -> void:
	self.content = _content
	self.child_items.assign(_child_items)

func _to_string() -> String:
	return "KillFeedItem(%s%s" % [self.content, ", %s)" % self.child_items if self.child_items.size() > 0 else ")"]

func WITH_CONTENT(_content : String) -> KillFeedItem:
	self.content = _content
	return self

func WITH_CHILDREN(_child_items : Array[KillFeedItem]) -> KillFeedItem:
	self.child_items.assign(_child_items)
	return self

static func FROM_EVENT_PAIR(event1 : Event, event2 : Event) -> KillFeedItem:
	match([event1.event_type, event2.event_type]):
		["CREATED", "ENTERED_HAND"]:
			return KillFeedItem.new(
				"-".join([
					"ICON_%s" % [event1.card.metadata.name],
					"ICON_EFFECTS_CAUSED",
					"ICON_%s" % [event2.card.metadata.name],
					"ICON_CREATED",
					"ICON_ENTERED_HAND"
				])
			)
		_:
			push_error("Valid event pair without feedification scheme")
			return KillFeedItem.new("")

static func FROM_EVENT(event : Event) -> KillFeedItem:
	match(event.event_type):
		"ENTERED_FIELD":
			return KillFeedItem.new(
				"-".join([
					"ICON_%s" % [event.card.metadata.name],
					"ICON_ENTERED_FIELD"
				])
			)
		"ENTERED_HAND":
			return KillFeedItem.new(
				"-".join([
					"ICON_%s" % [event.card.metadata.name],
					"ICON_ENTERED_HAND"
				])
			)
		"ENTERED_DECK":
			return KillFeedItem.new(
				"-".join([
					"ICON_%s" % [event.card.metadata.name],
					"ICON_ENTERED_DECK"
				])
			)
		_:
			push_error("Valid event (%s) without feedification scheme" % [event.event_type])
			return KillFeedItem.new("")