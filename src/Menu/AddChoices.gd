extends ToolButton

var dialog_node := preload("res://src/Nodes/Choice/ChoiceNode.tscn")


func _ready() -> void:
	connect("pressed", self, "_on_Pressed")


func _on_Pressed() -> void:
	Events.emit_signal("graph_node_added", dialog_node.instance())