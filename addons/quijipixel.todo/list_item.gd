tool
extends VBoxContainer

signal completed_task
signal uncompleted_task

var _id = ""

const MONTHS = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

func get_date(date):
	return str(date.day) + " " + MONTHS[date.month - 1] + " " + str(date.year)

func set_data(id, data, view="pending"):
	var col = ""
	var content = ""
	var creation_date = get_date(data.creation_date)
	match data.type:
		"Feature":
			col = Color(0.5, 1, 0.6)
		"Bug":
			col = Color(1, 0.3, 0.3)
		"Task":
			col = Color(0.5, 0.6, 1)
		"Remainder":
			col = Color(0.8, 0.3, 0.7)
		"Refactor":
			col = Color(0.3, 0.8, 0.7)
	get_node("checkbox").set_text(creation_date + " - " + data.type + ": ")
	get_node("checkbox").set("custom_colors/font_color", col)
	get_node("checkbox").set("custom_colors/font_color_pressed", col)
	get_node("text").set_text(data.task)
	var completed_on = ""
	if view == "completed":
		get_node("footer_text").set_text("completed on " + get_date(data.completion_date))
	
	
	_id = id
	set_tooltip(creation_date + " - " + data.type + ": " + data.task)
	get_node("checkbox").set_tooltip(creation_date + " - " + data.type + ": " + data.task)
	
	get_node("checkbox").set("pressed", view=="completed")



func finished_tween(object, key):
	queue_free()


func _on_checkbox_toggled( pressed ):
	if pressed:
		emit_signal("completed_task", _id)
	else:
		emit_signal("uncompleted_task", _id)
	var col = get_node("checkbox").get("custom_colors/font_color")
	var col_end = col
	col_end.a = 0
	get_node("tween").connect("tween_completed", self, "finished_tween")
	if pressed:
		get_node("tween").interpolate_property(get_node("checkbox"), "custom_colors/font_color_pressed", col, col_end, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	else:
		get_node("tween").interpolate_property(get_node("checkbox"), "custom_colors/font_color_hover", col, col_end, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		get_node("tween").interpolate_property(get_node("checkbox"), "custom_colors/font_color", col, col_end, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	get_node("tween").start()
