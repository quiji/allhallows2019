tool
extends VBoxContainer

signal edit_item
signal remove_item
signal duplicate_item

var _id = ""

func set_data(item_id, item_name):
	var col = ""

	var type_name = ''
	match item_id.split(".")[0]:
		"SpriteAnim2D":
			type_name = "SpriteAnim2D"
			col = Color(0.5, 1, 0.6)

	get_node("checkbox").set_text(item_name)
	get_node("checkbox").set("custom_colors/font_color", col)
	get_node("checkbox").set("custom_colors/font_color_pressed", col)
	get_node("text").set_text(type_name)
	
	_id = item_id
	set_tooltip(type_name + ": " + item_name)
	get_node("checkbox").set_tooltip(type_name + ": " + item_name)

func finished_tween(object, key):
	queue_free()


func disappear():
	var col = get_node("checkbox").get("custom_colors/font_color")
	var col_end = col
	col_end.a = 0
	get_node("tween").connect("tween_completed", self, "finished_tween")
	get_node("tween").interpolate_property(get_node("checkbox"), "custom_colors/font_color_hover", col, col_end, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	get_node("tween").interpolate_property(get_node("checkbox"), "custom_colors/font_color", col, col_end, 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	get_node("tween").start()

func is_checked():
	return $checkbox.pressed

func toggle_item():
	$checkbox.pressed = not $checkbox.pressed

func _on_edit_button_pressed():
	emit_signal("edit_item", self, _id)


func _on_remove_button_pressed():
	emit_signal("remove_item", self, _id)


func _on_duplicate_button_pressed():
	emit_signal("duplicate_item",self, _id)

