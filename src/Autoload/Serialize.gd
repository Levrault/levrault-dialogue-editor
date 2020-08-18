extends Node

var current_path := ''


func save_as(path: String) -> void:
	var file = File.new()
	file.open(path, File.WRITE)
	file.store_string(Json.to_string())
	file.close()
	current_path = path
	Editor.current_state = Editor.FileState.saved


func save() -> void:
	var file = File.new()
	file.open(current_path, File.WRITE)
	file.store_string(Json.to_string())
	file.close()
	Editor.current_state = Editor.FileState.saved


func load(path: String):
	print("LOAD has been called")
	var file = File.new()
	file.open(path, File.READ)
	var content = file.get_as_text()
	file.close()
	Editor.current_state = Editor.FileState.saved
	var parsed_result = JSON.parse(content)
	if parsed_result.error != OK:
		print("get_json: error while parsing")
		return
	Json.json_raw = parsed_result.result
	Editor.generate_graph(Json.json_raw)
