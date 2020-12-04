tool
extends EditorPlugin
const NOTES_FILE = "res://addons/quijipixel.notes/notes.md"

var note_editor = null
func _enter_tree():
	note_editor = preload("res://addons/quijipixel.notes/note_editor.tscn").instance()

	get_editor_interface().get_editor_viewport().add_child(note_editor)
	#get_editor_interface().get_editor_viewport().connect("resized", self, "on_resized");
	#on_resized();
	

	var notes = ""
	var file = File.new()
	if not file.file_exists(NOTES_FILE):
		file.open(NOTES_FILE, File.WRITE)
		file.store_string(notes)
		file.close()
	else:
		file.open(NOTES_FILE, File.READ)
		notes = file.get_as_text()
		file.close()
	
	note_editor.configure()
	note_editor.set_notes(notes)
	note_editor.hide()

func _exit_tree():
	get_editor_interface().get_editor_viewport().remove_child(note_editor)
	note_editor.free() 

func apply_changes():
	var notes = note_editor.get_notes()
	var file = File.new()

	file.open(NOTES_FILE, File.WRITE)
	file.store_string(notes)
	file.close()


func has_main_screen():
	return true

func get_plugin_name():
	return "Notes"

var _state = {} 
func get_state():
	return _state
	
func set_state(st):
	_state = st

func get_plugin_icon():
	return preload("res://addons/quijipixel.notes/icon.png")

func make_visible(visible):
	if visible:
		note_editor.show()
	else:
		note_editor.hide()
		apply_changes()


