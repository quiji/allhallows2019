tool
extends EditorPlugin
const LIST_FILE = "res://addons/quijipixel.todo/list.json"
var JsonBeautifier = load("res://addons/quijipixel.todo/lib/json.gd")

var dock = null
func _enter_tree():
	var json_b = JsonBeautifier.new()
	dock = preload("res://addons/quijipixel.todo/todo_dock.tscn").instance()

	add_control_to_dock( DOCK_SLOT_LEFT_UR, dock)
	
	var list = {completed = {}, pending = {}, comp_order = [], pend_order = []}
	var file = File.new()
	if not file.file_exists(LIST_FILE):
		file.open(LIST_FILE, File.WRITE)
		file.store_line(json_b.str_to_json(list))
		file.close()
	else:
		file.open(LIST_FILE, File.READ)
		list = parse_json(file.get_as_text())
		file.close()
		
	dock.configure_components()
	dock.set_file(LIST_FILE)
	dock.set_list_items(list)
	dock.populate()


func _exit_tree():
    remove_control_from_docks( dock ) 
    dock.free() 

