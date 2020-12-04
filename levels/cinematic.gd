extends Node2D

const Condition = preload("res://levels/cinematic_pieces/Condition.tscn")

export (NodePath) var player_node 
export (NodePath) var camera_crew_node 
export (bool) var debug = false


var player = null
var camera_crew = null
var level = null

var current_action
var action_list = []

func _ready():
		
	if player_node:
		player = get_node(player_node)

	if camera_crew_node:
		camera_crew = get_node(camera_crew_node)

	level = get_parent()
	
	append_nodes(get_children())

	execute()

func append_nodes(children) -> void:
	for i in range(children.size()):
		var child = children[i]
		
		if child.has_user_signal("action_finished"):
			child.connect("action_finished", self, "execute")
		elif child is Area2D:
			child.connect("body_entered", self, "_on_trigger_executed")
			child.enabled = false
		action_list.push_back(child)

func prepend_nodes(children) -> void:
	var i = children.size() - 1

	while i >= 0:

		var child = children[i]
		
		if child is Area2D:
			child.connect("body_entered", self, "_on_trigger_executed")
			child.enabled = false
		elif child.has_user_signal("action_finished"):
			child.connect("action_finished", self, "execute")
		
		action_list.push_front(child)

		i -= 1


func execute() -> void:
	
	if action_list.size() == 0:
		return
	
	current_action = action_list.pop_front()
	
	if current_action is Area2D:
		current_action.enabled = true
		return
	
	var wait: bool = current_action.execute()
	
	while action_list.size() > 0 and not wait and not current_action is Area2D:
		current_action = action_list.pop_front()
		
		if not current_action is Area2D:
			wait = current_action.execute()
		else:
			current_action.enabled = true


func _on_trigger_executed(body) -> void:
	current_action.enabled = false
	

	
	if debug:
		Console.add_log("triggered", current_action.name)


	
	execute()

