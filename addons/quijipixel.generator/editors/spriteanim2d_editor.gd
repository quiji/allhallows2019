tool
extends WindowDialog

var _id = null
var gen = null

enum ReactTypes {REACT_NO, REACT_STEP, REACT_ROAR, REACT_WHIP, REACT_SHOOT}

onready var debug = $panel/margins/container/debug

onready var spritesheet_edit = $panel/margins/container/spritesheet/spritesheet_container/spritesheet_edit
onready var spritesheet_width_edit = $panel/margins/container/spritesheet/sprite_container/spritesheet_size/sprite_sheet_width_edit
onready var spritesheet_height_edit = $panel/margins/container/spritesheet/sprite_container/spritesheet_size/sprite_sheet_height_edit2

onready var sprite_preview = $panel/margins/container/sprite_preview/sprite
onready var sprite_preview_panel = $panel/margins/container/sprite_preview

onready var new_anim_name_edit = $panel/margins/container/animation_list/header/buttons/new_anim_name
onready var animation_list = $panel/margins/container/animation_list/list

onready var animation_editor = $panel/margins/container/animation
onready var frame_list = $panel/margins/container/animation/margins/frame_list

onready var animation_toolbar = $panel/margins/container/animation_toolbar
onready var animation_options = $panel/margins/container/anim_options

onready var animation_edit_buttons = $panel/margins/container/animation_toolbar/frame_form/edit_buttons
onready var animation_save_button = $panel/margins/container/animation_toolbar/frame_form/save_frame_button
onready var frame_form = $panel/margins/container/animation_toolbar/frame_form
onready var frame_form_id = $panel/margins/container/animation_toolbar/frame_form/frame
onready var frame_form_time = $panel/margins/container/animation_toolbar/frame_form/time
onready var frame_form_react = $panel/margins/container/animation_toolbar/frame_form/react
onready var frame_form_param = $panel/margins/container/animation_toolbar/frame_form/param
onready var frame_form_offset = $panel/margins/container/animation_toolbar/frame_form/offset_by

onready var play_button = $panel/margins/container/play_button
onready var loop_button = $panel/margins/container/anim_options/loop_button
onready var ping_button = $panel/margins/container/anim_options/ping_button

onready var func_label = $panel/margins/container/func_label

onready var target_file_edit = $panel/margins/container/generator_options/target_file_edit
onready var attached_script_edit = $panel/margins/container/generator_options/attach_script_edit
onready var dir_exist_label = $panel/margins/container/generator_options/dir_exist
onready var script_exist_label = $panel/margins/container/generator_options/script_exist
onready var generator_name_edit = $panel/margins/container/generator_options/generator_name_edit

func _ready():
	animation_editor.hide()
	animation_toolbar.hide()
	animation_edit_buttons.hide()
	animation_save_button.show()
	frame_form.hide()
	animation_options.hide()
	new_anim_name_edit.hide()

func edit_generator(id):
	_id = id
	gen = get_parent().list.generators[id].duplicate()
	window_title = "Sprite Animation 2D Editing: " + gen.name

	if gen.has("sprite_width"):
		spritesheet_width_edit.text = str(gen.sprite_width)

	if gen.has("sprite_height"):
		spritesheet_height_edit.text = str(gen.sprite_height)

	if gen.has("spritesheet"):
		spritesheet_edit.text = gen.spritesheet
		load_sprite()

	if gen.has("animations"):
		for key in gen.animations:
			animation_list.add_item(key)
			create_preview_animation(key)

	if gen.has("target_dir"):
		target_file_edit.text = gen.target_dir
		
	if gen.has("attached_script"):
		attached_script_edit.text = gen.attached_script

	generator_name_edit.text = gen.name


func _on_cancel_button_pressed():
	get_parent().load_list_from_file()
	hide()

func _on_save_button_pressed():

	if target_file_edit.text != '':
		gen.target_dir = target_file_edit.text
	
	if attached_script_edit.text != '':
		gen.attached_script = attached_script_edit.text

	get_parent().list.generators[_id] = gen.duplicate()
	get_parent().list.generators[_id].name = generator_name_edit.text
	get_parent().save_list_to_file()
	get_parent().update_list()
	hide()
	
func _on_save_gen_button_pressed():

	if target_file_edit.text != '':
		gen.target_dir = target_file_edit.text
	
	if attached_script_edit.text != '':
		gen.attached_script = attached_script_edit.text


	get_parent().list.generators[_id] = gen.duplicate()
	get_parent().list.generators[_id].name = generator_name_edit.text
	get_parent().save_list_to_file()
	get_parent().run_generator([_id])
	get_parent().update_list()
	hide()


func load_sprite():
	sprite_preview.position = sprite_preview_panel.rect_size / 2
	sprite_preview.texture = load(gen.spritesheet)
	var size = sprite_preview.texture.get_size()

	if gen.has("sprite_width") and gen.has("sprite_height"):
		sprite_preview.vframes = int(size.y / int(gen.sprite_height))
		sprite_preview.hframes = int(size.x / int(gen.sprite_width))
		size = Vector2(gen.sprite_width, gen.sprite_height)

	var scale = Vector2()
	if size.x > size.y:
		scale.x = sprite_preview_panel.rect_size.x / size.x
		scale.y = scale.x
	else: 
		scale.y = sprite_preview_panel.rect_size.y / size.y
		scale.x = scale.y
		
	sprite_preview.scale = scale
	

func _on_spriteanim2d_editor_popup_hide():
	self.queue_free()


func _on_sprite_sheet_width_edit_text_entered(new_text):
	if new_text.is_valid_integer() or new_text.is_valid_float():
		gen.sprite_width = int(new_text)
		load_sprite()
	else:
		# Not valid integer
		pass

func _on_sprite_sheet_height_edit2_text_entered(new_text):
	if new_text.is_valid_integer() or new_text.is_valid_float():
		gen.sprite_height = int(new_text)
		load_sprite()
	else:
		# Not valid integer
		pass

func _on_spritesheet_edit_text_entered(new_text):
	var file = File.new()
	if file.file_exists(new_text):
		gen.spritesheet = new_text
		load_sprite()
	else:
		# File doesn't exist
		pass


func _on_remove_animation_button_pressed():
	var ids = animation_list.get_selected_items()
	if ids.size() > 0:
		var anim_name = animation_list.get_item_text(ids[0])
		animation_editor.hide()
		animation_toolbar.hide()
		frame_form.hide()
		animation_options.hide()
		animation_list.remove_item(ids[0])
		gen.animations.erase(anim_name)
		remove_preview_animation(anim_name)
	else:
		# No animation is selected for deletion
		pass # replace with function body

var anim_to_duplicate = null
func _on_new_animation_button_pressed():
	anim_to_duplicate = null
	new_anim_name_edit.show()
	new_anim_name_edit.text = 'Animation Name'
	new_anim_name_edit.grab_focus()
	new_anim_name_edit.select_all()

func _on_new_anim_name_text_entered(new_text):
	if anim_to_duplicate == null:
		if not gen.has("animations"):
			gen.animations = {}
	
		if not gen.animations.has(new_text):
			gen.animations[new_text] = {}
	
			new_anim_name_edit.hide()
			animation_list.add_item(new_text)
			animation_list.select(animation_list.get_item_count() - 1)
			_on_list_item_selected(animation_list.get_item_count() - 1)
			create_preview_animation(new_text)
		else:
			# That animation already exists
			pass
	else:
		if not gen.has("animations"):
			gen.animations = {}
		
		if not gen.animations.has(new_text):
			gen.animations[new_text] = gen.animations[anim_to_duplicate].duplicate()
	
			new_anim_name_edit.hide()
			animation_list.add_item(new_text)
			animation_list.select(animation_list.get_item_count() - 1)
			_on_list_item_selected(animation_list.get_item_count() - 1)
			create_preview_animation(new_text)
		else:
			# That animation already exists
			pass


var selected_anim = null
var selected_idx = null
var selected_anim_index = null
func _on_list_item_selected(index):
	selected_anim_index = index
	
	var j = 0
	var children = frame_list.get_children()
	while j < frame_list.get_child_count():
		children[j].queue_free()
		j += 1

	var anim_name = animation_list.get_item_text(index)
	animation_editor.show()
	frame_form.show()
	animation_options.show()
	animation_toolbar.show()
	_on_cancel_frame_button_pressed()
	
	
	selected_anim = anim_name
	
	if gen.animations[anim_name].has("frames"):
		var i = 0
		while i < gen.animations[anim_name].frames.size():
			add_number_button(str(gen.animations[anim_name].frames[i].id), i)
			i += 1

	if not gen.animations[anim_name].has("loop"):
		gen.animations[anim_name].loop = false
		
	loop_button.pressed = gen.animations[anim_name].loop
	
	if not gen.animations[anim_name].has("ping_pong"):
		gen.animations[anim_name].ping_pong = false

	ping_button.pressed = gen.animations[anim_name].ping_pong


func _on_save_frame_button_pressed():
	if not gen.animations[selected_anim].has("frames"):
		gen.animations[selected_anim].frames = []

	var frame = {
		id = int(frame_form_id.text),
		time = int(frame_form_time.text),
		react = frame_form_param.text
		#frame_form_react.get_selected_id(),
		#param = frame_form_param.text
	}

	_on_cancel_frame_button_pressed()
	gen.animations[selected_anim].frames.push_back(frame)
	add_number_button(str(frame.id), gen.animations[selected_anim].frames.size() - 1)
	create_preview_animation(selected_anim)


func add_number_button(btn_name, number):
	var frame_button = preload("res://addons/quijipixel.generator/editors/NumberButton.tscn").instance()
	frame_list.add_child(frame_button)
	frame_button.set_button(btn_name, number)
	frame_button.connect("number_pressed", self, "edit_frame")

func edit_frame(idx):
	selected_idx = idx
	frame_form_id.text = str(gen.animations[selected_anim].frames[idx].id)
	frame_form_time.text = str(gen.animations[selected_anim].frames[idx].time)
	#frame_form_react.select(gen.animations[selected_anim].frames[idx].react)
	frame_form_param.text = gen.animations[selected_anim].frames[idx].react
	#gen.animations[selected_anim].frames[idx].param

	animation_save_button.hide()
	animation_edit_buttons.show()



func _on_edit_frame_button_pressed():
	gen.animations[selected_anim].frames[selected_idx] = {
		id = int(frame_form_id.text),
		time = int(frame_form_time.text),
		react = frame_form_param.text
		#frame_form_react.get_selected_id(),
		#param = frame_form_param.text
	}
	var children = frame_list.get_children()
	children[selected_idx].text = frame_form_id.text
	_on_cancel_frame_button_pressed()
	create_preview_animation(selected_anim)

func _on_remove_frame_button_pressed():
	gen.animations[selected_anim].frames.remove(selected_idx)
	var children = frame_list.get_children()
	var i = selected_idx + 1
	while i < children.size():
		children[i].sub(1)
		i += 1
	children[selected_idx].queue_free()
	_on_cancel_frame_button_pressed()
	create_preview_animation(selected_anim)

func _on_cancel_frame_button_pressed():
	animation_save_button.show()
	animation_edit_buttons.hide()

	frame_form_id.text = '1'
	frame_form_time.text = '0'
	#frame_form_react.select(REACT_NO)
	frame_form_param.text = ''


func _on_frame_text_changed(new_text):
	var value = int(new_text)

	var total = sprite_preview.vframes * sprite_preview.hframes 

	if not $anim_player.is_playing() and value > 0 and value <= total:
		sprite_preview.frame = int(value - 1)



func _on_play_button_pressed():
	if play_button.text == "Play":
		var ids = animation_list.get_selected_items()
		if ids.size() > 0:
			var anim_name = animation_list.get_item_text(ids[0])
			
			if $anim_player.has_animation(anim_name):
				func_label.text = ''
				$anim_player.play(anim_name)
				play_button.text = "Stop"
	else:
		$anim_player.stop()
		play_button.text = "Play"


func create_preview_animation(key):
	var anim_obj = null
	if not $anim_player.has_animation(key):
		anim_obj = Animation.new()
		$anim_player.add_animation(key, anim_obj)
	else:
		anim_obj = $anim_player.get_animation(key)

	if gen.animations[key].has("frames"):
		anim_obj.clear()
		var track_idx = anim_obj.add_track(Animation.TYPE_VALUE)

		var track_method_idx = anim_obj.add_track(Animation.TYPE_VALUE)
		
		anim_obj.track_set_path(track_idx, 'panel/margins/container/sprite_preview/sprite:frame')
		anim_obj.track_set_path(track_method_idx, 'panel/margins/container/func_label:text')
		
		anim_obj.step = 0.016
		
		if gen.animations[key].has("loop"):
			anim_obj.loop = gen.animations[key].loop
		
		if not gen.animations[key].has("ping_pong"):
			gen.animations[key].ping_pong = false

		var delta = 0.0
		var i = 0
		var react_call = ""
		while i < gen.animations[key].frames.size():
			if gen.animations[key].frames[i].id - 1 >= 0:
				
				anim_obj.track_insert_key(track_idx, delta, gen.animations[key].frames[i].id - 1, Animation.UPDATE_CONTINUOUS)
				
				"""
				if gen.animations[key].frames[i].react != REACT_NO:
					react_call = ""
					if gen.animations[key].frames[i].react == REACT_STEP:
						react_call = "react(Step)"
					elif gen.animations[key].frames[i].react == REACT_ROAR:
						react_call = "react(Roar)"
					elif gen.animations[key].frames[i].react == REACT_WHIP:
						react_call = "react(Whip)"
					elif gen.animations[key].frames[i].react ==  REACT_SHOOT:
						react_call = "react(Shoot)"
						
					anim_obj.track_insert_key(track_method_idx, delta, react_call, Animation.UPDATE_CONTINUOUS)
				"""
				
				delta += gen.animations[key].frames[i].time / 1000.0
			i += 1
		

		i -= 1
		while i > 0 and gen.animations[key].ping_pong:
			i -= 1
			if gen.animations[key].frames[i].id - 1 >= 0:
				anim_obj.track_insert_key(track_idx, delta, gen.animations[key].frames[i].id - 1, Animation.UPDATE_CONTINUOUS)
	
				"""
				if gen.animations[key].frames[i].react != REACT_NO:
					react_call = ""
					if gen.animations[key].frames[i].react == REACT_STEP:
						react_call = "react(Step)"
					elif gen.animations[key].frames[i].react == REACT_ROAR:
						react_call = "react(Roar)"
					elif gen.animations[key].frames[i].react == REACT_WHIP:
						react_call = "react(Whip)"
					elif gen.animations[key].frames[i].react == REACT_SHOOT:
						react_call = "react(Shoot)"

					anim_obj.track_insert_key(track_method_idx, delta, react_call, Animation.UPDATE_CONTINUOUS)
				"""
				
				delta += gen.animations[key].frames[i].time / 1000.0
		
		anim_obj.length = delta

		
func remove_preview_animation(anim_name):
	if $anim_player.has_animation(anim_name):
		$anim_player.remove_animation(anim_name)


func _on_anim_player_animation_finished(anim_name):
	play_button.text = "Play"


func _on_loop_button_pressed():
	gen.animations[selected_anim].loop = loop_button.pressed
	create_preview_animation(selected_anim)

func _on_ping_button_pressed():
	gen.animations[selected_anim].ping_pong = ping_button.pressed
	create_preview_animation(selected_anim)



func _on_target_file_edit_text_changed(new_text):
	var dir = Directory.new()
	if dir.dir_exists(new_text):
		dir_exist_label.text = "OK!"
	else:
		dir_exist_label.text = "NO!"
	

func _on_attach_script_edit_text_changed(new_text):
	var dir = Directory.new()
	if dir.file_exists(new_text):
		script_exist_label.text = "OK!"
	else:
		script_exist_label.text = "NO!"


func _on_offset_button_pressed():
	debug.show()
	debug.text = selected_anim + " moving " + str(frame_form_offset.value) + " frames."
	var i = 0
	while i < gen.animations[selected_anim].frames.size():
		gen.animations[selected_anim].frames[i].id += frame_form_offset.value
		i += 1
	create_preview_animation(selected_anim)
	_on_list_item_selected(selected_anim_index)



func _on_duplicate_button_pressed():
	anim_to_duplicate = selected_anim
	new_anim_name_edit.show()
	new_anim_name_edit.text = 'Animation Name'
	new_anim_name_edit.grab_focus()
	new_anim_name_edit.select_all()
	
	
