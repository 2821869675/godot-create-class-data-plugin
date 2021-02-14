tool
extends EditorPlugin

class file_data:
	extends Reference
	var path: String
	var is_dir: bool


func _enter_tree() -> void:
	
	add_tool_menu_item("创建类数据库文件",self,"start")
	
func _exit_tree() -> void:
	remove_tool_menu_item("创建类数据库文件")

func start(_a) -> void:
	var dir: Directory = Directory.new()
	var file: File = File.new()
	var files: Array = [file_data.new()]
	var classs: Dictionary = {}
	files[0].path = "res://"
	files[0].is_dir = true
	var error: int = 0
	
	while not files.empty():
		var fd:file_data = files.pop_front()
		if fd.is_dir:
			if dir.open(fd.path) == OK:
				dir.list_dir_begin(true)
				var name: String = dir.get_next()
				while not name.empty():
					if dir.current_is_dir() or name.match("*.gd"):
						var nfd: file_data = file_data.new()
						nfd.path = fd.path + name + ("/" if dir.current_is_dir() else "")
						nfd.is_dir = dir.current_is_dir()
						files.push_back(nfd)
					name = dir.get_next()
			else:
				error += 1
		else:
			if file.open(fd.path,File.READ) == OK:
				for i in range(20):
					var ld: String = file.get_line()
					if ld.match("class_name *"):
						classs[ld.substr(11)] = fd.path
						break
					if file.eof_reached():
						break
				file.close()
			else:
				error += 1
			
		
		
	
	if file.open("res://data/class data.json",File.WRITE) == OK:
		file.store_string(to_json(classs))
		file.close()
	else:
		error += 1
	
	print("创建数据库完成," + ("没有出现错误" if error == 0 else ("出现了%d个错误" % error)))





