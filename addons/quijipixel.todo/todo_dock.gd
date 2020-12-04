tool
extends Panel

const PENDING = "pending"
const COMPLETED = "completed"

var JsonBeautifier = load("res://addons/quijipixel.todo/lib/json.gd")
var _save_file = ''
var _list = {completed = {}, pending = {}, comp_order = [], pend_order = []}

var _list_node = null

var _editor_interface = null
var json_b = null

func configure_components():
	_list_node = get_node("margins/scroll_container/list_container")
	json_b = JsonBeautifier.new()

func add_item(item, item_name):
	var checkbox = preload("res://addons/quijipixel.todo/list_item.tscn").instance()
	checkbox.set_data(item_name, item, _view)

	_list_node.add_child(checkbox)
	
	checkbox.connect("completed_task", self, "completed_task")
	checkbox.connect("uncompleted_task", self, "uncompleted_task")

func clear_items():
	for child in _list_node.get_children():
	    child.queue_free()

func update_name():
	if _list.pending.size() > 0:
		set_name("To do (" + str(_list.pending.size()) + ")")
	else:
		set_name("To do")

	var total = _list.pending.size() + _list.completed.size()
	get_node("footer/container/summary").set_text("Completed " + str(_list.completed.size()) + " / " + str(total) + " Tasks")

func set_file(_filename):
	_save_file = _filename
	
func set_list_items(items):
	_list = items
	
func populate(view=PENDING):
	
	if _list_node.get_child_count() > 0:
		clear_items()

	var ordered_list
	if view == PENDING:
		ordered_list = _list.pend_order
	else:
		ordered_list = _list.comp_order

	for i in ordered_list:
		add_item(_list[view][i], i)
	update_name()



func _on_cancel_button_pressed():
	get_node("add_task_dialog").hide()


func _on_add_button_pressed():
	var task_type = get_node("add_task_dialog/margins/Container/task_type")
	var task_text = get_node("add_task_dialog/margins/Container/task_text")

	get_node("add_task_dialog").hide()
	var task = task_text.get_text()
	var type = str(task_type.get_item_text(task_type.get_selected_id()))

	var id = "task." + str(_list.pending.size() + _list.completed.size())
	_list.pending[id] = {}
	_list.pending[id]["task"] = task
	_list.pending[id]["type"] = type
	_list.pending[id]["creation_date"] = OS.get_datetime()
	
	add_item(_list.pending[id], id)
	
	_list.pend_order.push_back(id)
	
	var file = File.new()
	file.open(_save_file, File.WRITE)
	file.store_line(json_b.str_to_json(_list))
	file.close()
	update_name()


func _on_add_task_button_pressed():
	get_node("add_task_dialog/margins/Container/task_text").set_text("")
	get_node("add_task_dialog").popup_centered()
	
func completed_task(id):
	
	var patch = 0
	var minor = 0

	if ProjectSettings.has_setting("Project/patch"):
		patch = ProjectSettings.get_setting("Project/patch")

	if ProjectSettings.has_setting("Project/minor"):
		minor = ProjectSettings.get_setting("Project/minor")
		
	match _list.pending[id].type:
		'Bug':
			patch += 1
		'Task':
			minor += 1
		'Feature':
			minor += 1
		'Refactor':
			minor += 1

	ProjectSettings.set_setting("Project/patch", patch)
	ProjectSettings.set_setting("Project/minor", minor)
	ProjectSettings.save()

	_list.completed[id] = _list.pending[id]
	_list.completed[id].completion_date = OS.get_datetime()
	_list.pending.erase(id)
	_list.pend_order.erase(id)
	_list.comp_order.push_back(id)

	var file = File.new()
	file.open(_save_file, File.WRITE)
	file.store_line(json_b.str_to_json(_list))
	file.close()
	update_name()

func uncompleted_task(id):
	_list.pending[id] = _list.completed[id]
	if _list.pending[id].has("completion_date"):
		_list.pending[id].erase("completion_date")

	_list.completed.erase(id)
	_list.pend_order.push_back(id)
	_list.comp_order.erase(id)

	var file = File.new()
	file.open(_save_file, File.WRITE)
	file.store_line(json_b.str_to_json(_list))
	file.close()
	update_name()


var _view = PENDING
func _on_swap_view_pressed():
	if _view == PENDING:
		get_node("footer/container/swap_view").set_text("View Pending Tasks")
		_view = COMPLETED
	elif _view == COMPLETED:
		get_node("footer/container/swap_view").set_text("View Completed Tasks")
		_view = PENDING
	populate(_view)

