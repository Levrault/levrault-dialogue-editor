extends AnimatedToolButton


func _ready() -> void:
	connect("pressed", self, "_on_Pressed")


func _on_Pressed() -> void:
	modulate = COLOR
	Events.emit_signal("layout_preview_toggled")
