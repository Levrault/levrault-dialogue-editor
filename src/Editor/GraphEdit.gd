extends GraphEdit


func _ready() -> void:
	connect("connection_request", self, "_on_Connection_request")
	connect("disconnection_request", self, "_on_Disconnection_request")


func _on_Connection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	var from_node = get_node(from)
	var to_node = get_node(to)

	# choice to dialogue relation
	if from_node.TYPE == Editor.Type.choice and to_node.TYPE == Editor.Type.choice:
		print_debug("ERROR: choice to choice relation")
		# TODO: ADD warning message
		return

	if from_node.TYPE == Editor.Type.start and to_node.TYPE == Editor.Type.choice:
		print_debug("ERROR: start to choice relation")
		# TODO: ADD warning message
		return

	# START -- DIALOGUE
	if from_node.TYPE == Editor.Type.start and to_node.TYPE == Editor.Type.dialogue:
		# is selected dialogue (from) is already connected to another dialogue
		# Can only be connected to ONE dialogue but can be connected to multiple conditions
		if not from_node.connected_to_dialogue.empty():
			print_debug("WARNING: start is already connected to a dialogue, first connected will be disconnected")
			disconnect_node(
				from, from_slot, from_node.connected_to_dialogue, from_node.connected_slot
			)
			
		print_debug("connect start to dialogue relation")
		from_node.connected_to_dialogue = to
		from_node.connected_slot = to_slot

		Events.emit_signal("start_to_dialogue_relation_changed", to_node.uuid)

		connect_node(from, from_slot, to, to_slot)
		return

	# DIALOGUE -- DIALOGUE
	if from_node.TYPE == Editor.Type.dialogue and to_node.TYPE == Editor.Type.dialogue:
		print_debug("connect dialogue to dialogue relation")
		connect_node(from, from_slot, to, to_slot)
		Events.emit_signal("dialogue_to_dialogue_relation_created", from_node.uuid, to_node.uuid)
		return

	# DIALOGUE -- CHOICE
	if from_node.TYPE == Editor.Type.dialogue and to_node.TYPE == Editor.Type.choice:
		print_debug("connect dialogue to choice relation")
		connect_node(from, from_slot, to, to_slot)
		Events.emit_signal("dialogue_to_choice_relation_created", from_node.uuid, to_node.uuid)
		return

	# CHOICE -- DIALOGUE
	if from_node.TYPE == Editor.Type.choice and to_node.TYPE == Editor.Type.dialogue:
		print_debug("connect choice to dialogue relation")
		connect_node(from, from_slot, to, to_slot)
		Events.emit_signal("choice_to_dialogue_relation_created", from_node.uuid, to_node.uuid)
		return


func _on_Disconnection_request(from: String, from_slot: int, to: String, to_slot: int) -> void:
	print(from)
	var from_node = get_node(from)
	var to_node = get_node(to)
	# DIALOGUE -- DIALOGUE
	if from_node.TYPE == Editor.Type.dialogue and to_node.TYPE == Editor.Type.dialogue:
		print_debug("disconnect dialogue to dialogue relation")
		disconnect_node(from, from_slot, to, to_slot)
		Events.emit_signal("dialogue_to_dialogue_relation_deleted", from_node.uuid)
		return

	# DIALOGUE -- CHOICE
	if from_node.TYPE == Editor.Type.dialogue and to_node.TYPE == Editor.Type.choice:
		print_debug("disconnect dialogue to choice relation")
		disconnect_node(from, from_slot, to, to_slot)
		Events.emit_signal("dialogue_to_choice_relation_deleted", from_node.uuid, to_node.uuid)
		return

	# CHOICE -- DIALOGUE
	if from_node.TYPE == Editor.Type.choice and to_node.TYPE == Editor.Type.dialogue:
		print_debug("disconnect choice to dialogue relation")
		disconnect_node(from, from_slot, to, to_slot)
		Events.emit_signal("choice_to_dialogue_relation_deleted", from_node.uuid)
		return
