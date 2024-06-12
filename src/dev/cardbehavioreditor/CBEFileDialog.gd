class_name CBEFileDialog
extends FileDialog

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.file_selected.connect(
		func(path : String) -> void:
			print(path)
	)
