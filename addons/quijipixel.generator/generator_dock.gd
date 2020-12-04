tool
extends Panel

const LIST_FILE = "res://addons/quijipixel.generator/list.json"

enum GeneratorTypes {SpriteAnim2D = 0}

var JsonLib = load("res://addons/quijipixel.generator/lib/json.gd")

var list = {generators = {}, last_id = 0}
var json_b = null
var _current_key = null

func _ready():
	set_name("Generator")

func configure_components():
	
	json_b = JsonLib.new()
	
	var file = File.new()
	if not file.file_exists(LIST_FILE):
		file.open(LIST_FILE, File.WRITE)
		file.store_line(json_b.str_to_json(list))
		file.close()
	else:
		load_list_from_file()
	update_list()


func _on_add_generator_button_pressed():
	$create_dialog.popup_centered()
	$create_dialog/name_edit.text = ''
	$create_dialog/error_text.text = ''


func _on_create_button_pressed():
	if $create_dialog/name_edit.text.strip_edges() == "":
		$create_dialog/error_text.text = "The Generator must have a name!!"
	else:
		$create_dialog.hide()
		var id = list.last_id
	
		match $create_dialog/type_select.get_selected_id():
			GeneratorTypes.SpriteAnim2D:
				id = "SpriteAnim2D." + str(id)
				list.generators[id] = {
					name = $create_dialog/name_edit.text
				}
				list.last_id += 1
	
		save_list_to_file()
		update_list(id)

func _on_cancel_button_pressed():
	$create_dialog.hide()


func save_list_to_file():
	var file = File.new()
	file.open(LIST_FILE, File.WRITE)
	file.store_line(json_b.str_to_json(list))
	file.close()

func load_list_from_file():
	var file = File.new()
	file.open(LIST_FILE, File.READ)
	list = parse_json(file.get_as_text())
	file.close()


func update_list(id=null):
	if id != null:
		add_item(id, list.generators[id].name)
		_on_edit_item(null, id)
	else:
		clear_items()
		
		for key in list.generators:
			add_item(key, list.generators[key].name)

func add_item(item_id, item_name):
	var checkbox = preload("res://addons/quijipixel.generator/generator_list_item.tscn").instance()
	checkbox.set_data(item_id, item_name)

	checkbox.connect("edit_item", self, "_on_edit_item")
	checkbox.connect("remove_item", self, "_on_remove_item")
	checkbox.connect("duplicate_item", self, "_on_duplicate_item")
	
	$generators/scroll_container/list_container.add_child(checkbox)

func clear_items():
	for child in $generators/scroll_container/list_container.get_children():
	    child.queue_free()

func _on_edit_item(obj, id):
	var type = id.split(".")[0]
	match type:
		"SpriteAnim2D":
			var editor = load("res://addons/quijipixel.generator/editors/spriteanim2d_editor.tscn").instance()
			add_child(editor)

			editor.popup_centered()
			editor.edit_generator(id)

func _on_duplicate_item(obj, id):
	var type = id.split(".")[0]
	match type:
		"SpriteAnim2D":
			var new_id = list.last_id
			new_id = "SpriteAnim2D." + str(new_id)
			
			list.generators[new_id] = list.generators[id].duplicate()
			list.generators[new_id].name = " copy"
			list.last_id += 1
	
			save_list_to_file()
			update_list(new_id)



var _removing_obj = null
var _removing_id = null
func _on_remove_item(obj, id):
	$accept_remove_dialog.dialog_text = "Are you sure you want to remove '" + list.generators[id].name + "'?"
	$accept_remove_dialog.popup_centered()
	_removing_obj = obj
	_removing_id = id

func _on_accept_remove_dialog_confirmed():
	if _removing_obj != null:
		_removing_obj.disappear()
		list.generators.erase(_removing_id)
		save_list_to_file()
		_removing_obj = null


func _on_mark_all_button_pressed():
	for child in $generators/scroll_container/list_container.get_children():
	    child.toggle_item()


func _on_run_marked_button_pressed():
	var gens = []
	for child in $generators/scroll_container/list_container.get_children():
		if child.is_checked():
			gens.push_back(child._id)
	
	run_generator(gens)

func run_generator(gens):
	var generator = load("res://addons/quijipixel.generator/GeneratorConsole.tscn").instance()
	add_child(generator)

	generator.popup_centered()
	var i = 0
	while i < gens.size():
		generator.run(gens[i])
		i += 1

