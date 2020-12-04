tool
extends WindowDialog

onready var console = $margins/panel/console
onready var ok_button = $margins/panel/ok_button


const RED = Color(1.0, 0.3, 0.3)
const BLUE = Color(0.3, 0.3, 1.0)
const GREEN = Color(0.3, 1.0, 0.3)

func _on_ok_button_pressed():
	hide()
	queue_free()


func run(gen):
	
	var type = gen.split(".")[0]
	match type:
		"SpriteAnim2D":
			generate_animation(get_parent().list.generators[gen])

func generate_animation(gen):
	var dir = Directory.new()
	ok_button.disabled = true
	
	br()
	br()
	append_line("Generating Sprite Animation 2D. Working on ")
	print_line(gen.name, BLUE)
	br()
	print_line("Validating generator...")
	
	var validated = true
	if not gen.has("spritesheet") or not dir.file_exists(gen.spritesheet):
		print_line("Spritesheet not provided or invalid file.", RED)
		validated = false
	
	if not gen.has("target_dir") or not dir.dir_exists(gen.target_dir):
		print_line("Target directory not provided or invalid directory.", RED)
		validated = false

	if gen.has("attached_script") and not dir.file_exists(gen.attached_script):
		print_line("Attached script provided doesn't exist.", RED)
		validated = false


	if not validated:
		print_line("Couldn't generate animation scene.", RED)
	else:
		print_line("Generator validated! Proceeding to scene generation...", GREEN)
		
		var scene_name = gen.name.to_lower().replace(" ", "_")
		append_line("Proceeding to scene structure generation for ")
		append_line(scene_name, BLUE)
		print_line("...")

		var scene_node = Node2D.new()
		var sprite = Sprite.new()
		var anim_player = AnimationPlayer.new()
		
		scene_node.name = scene_name
		scene_node.add_child(sprite)
		sprite.owner = scene_node
		sprite.name = "sprite"
		
		scene_node.add_child(anim_player)
		anim_player.owner = scene_node
		anim_player.name = "anim_player"
		
		
		sprite.texture = load(gen.spritesheet)
		var spritesheet_size = sprite.texture.get_size()
		sprite.vframes = int(spritesheet_size.y / int(gen.sprite_height))
		sprite.hframes = int(spritesheet_size.x / int(gen.sprite_width))


		for anim_name in gen.animations:
			append_line("Creating animation ")
			append_line(anim_name, BLUE)
			print_line("...")

			var anim = Animation.new()
			anim_player.add_animation(anim_name, anim)
	
			var track_idx = anim.add_track(Animation.TYPE_VALUE)
			var track_method_idx = anim.add_track(Animation.TYPE_METHOD)
			
			anim.track_set_path(track_idx, 'sprite:frame')
			anim.track_set_path(track_method_idx, '.')

			# step in seconds for 60 fps
			anim.step = 1.0/60.0
			
			anim.loop = gen.animations[anim_name].loop

			var delta = 0.0
			var i = 0
			while i < gen.animations[anim_name].frames.size():
				if gen.animations[anim_name].frames[i].id - 1 >= 0:
					
					anim.track_insert_key(track_idx, delta, gen.animations[anim_name].frames[i].id - 1, Animation.UPDATE_CONTINUOUS)
					
					if gen.animations[anim_name].frames[i].react != "":
						anim.track_insert_key(track_method_idx, delta, {method = "react", args = [gen.animations[anim_name].frames[i].react] })

					delta += gen.animations[anim_name].frames[i].time / 1000.0

				i += 1

			i -= 1
			while i > 0 and gen.animations[anim_name].ping_pong:
				i -= 1
				if gen.animations[anim_name].frames[i].id - 1 >= 0:
					anim.track_insert_key(track_idx, delta, gen.animations[anim_name].frames[i].id - 1, Animation.UPDATE_CONTINUOUS)
					
					if gen.animations[anim_name].frames[i].react != "":
						anim.track_insert_key(track_method_idx, delta, {method = "react", args = [gen.animations[anim_name].frames[i].react] })

					delta += gen.animations[anim_name].frames[i].time / 1000.0
			anim.length = delta

		
		
		if gen.has("attached_script"):
			scene_node.set_script(load(gen.attached_script))
			append_line("Attached script ")
			print_line(gen.attached_script, BLUE)
	
		print_line("Attempting to pack scene...")

		var target_filename = gen.target_dir + '/gen_' + scene_name + '.tscn'
		var packed_scene = PackedScene.new()
		packed_scene.pack(scene_node)
		append_line("Saving scene to ")
		print_line(target_filename, BLUE)
		

		if ResourceSaver.save(target_filename, packed_scene) != OK:
			print_line("Couldn't save generated file, generation failed.", RED)
		else:
			print_line("Scene generated succesfully!!", GREEN)
	
	br()

	ok_button.disabled = false

# Printing to console methods

func print_line(line, color=null):
	var pre=""
	var post=""
	if color != null:
		pre = "[color=#" + color.to_html() + "]"
		post ="[/color]"
	console.append_bbcode(pre+line+post)
	console.newline()

func append_line(line, color=null):
	var pre=""
	var post=""
	if color != null:
		pre = "[color=#" + color.to_html() + "]"
		post ="[/color]"
	console.append_bbcode(pre+line+post)

func br():
	console.newline()
