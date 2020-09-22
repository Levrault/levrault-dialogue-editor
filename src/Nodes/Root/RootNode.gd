# Start node are already added to the scene
# Can only have one starting node
# - Can connect to one dialogue node
# - Can connect to multiple conditions
extends GraphEditorNode

const TYPE = Editor.Type.root

var right_dialogue_connection := ""
var right_dialogue_connection_slot := 0
var right_conditions_connection := []
var right_conditions_connection_slot := 0


func _ready() -> void:
	if not is_loading:
		values = {"__editor": {"uuid": 'root', "offset": [offset.x, offset.y]}, "data": {}}
	uuid = "root"
	Store.json_raw["root"] = values.data
	Store.root_node = self
