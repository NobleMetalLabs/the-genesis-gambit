class_name CBEEditDescriptionPanel
extends PopupPanel

@onready var editor : CardBehaviorEditor = get_parent()
@onready var text_edit : TextEdit = $"%TEXT-EDIT"
@onready var submit_button : Button = $"%BUTTON"

func _ready() -> void:
	self.about_to_popup.connect(
		func fetch_existing_description() -> void:
			text_edit.text = editor.currently_editing_card_behavior.description
	)
	self.submit_button.pressed.connect(
		func save_description() -> void:
			editor.currently_editing_card_behavior.description = text_edit.text
			self.hide()
	)
	