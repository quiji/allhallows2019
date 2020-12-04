const INDENT = '  '

static func str_to_json(dict, level = 0):
	
	var content = ""
	match typeof(dict):
		TYPE_STRING:
			content += '"' + dict.json_escape() + '"'
		TYPE_BOOL:
			if dict:
				content += "true"
			else:
				content += "false"
		TYPE_DICTIONARY:
			content += "{\n"
			
			var i = 1
			for key in dict:
				
				var comma = ""
				if i < dict.size():
					i += 1
					comma = ","
					
				content += get_indent_for(level + 1) + '"' + key + '": ' + str_to_json(dict[key], level + 1) + comma + '\n'
			content += get_indent_for(level) + "}"
		TYPE_ARRAY:
			content += "[\n"
			var j = 0
			var i = 1
			while j < dict.size():
				
				var comma = ""
				if i < dict.size():
					i += 1
					comma = ","
					
				content += get_indent_for(level + 1) + str_to_json(dict[j], level + 1) + comma + '\n'
				j += 1
				
			content += get_indent_for(level) + "]"
		_:
			content += str(dict)

	return content

static func get_indent_for(lvl):
	if lvl <= 0:
		return ""
	else:
		return INDENT + get_indent_for(lvl - 1)