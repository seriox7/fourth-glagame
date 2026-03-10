extends Control

@onready var character = %CHARACTER
@onready var dialog_ui: Control = %"Dialog UI"

const dialog_lines : Array[String] = [
	"林峰：早上好哟，小雨，该起床了",
	"杨坤：这现在几点啊",
	"柏林：zzz",
]
func _ready() -> void:
	pass



func _process(delta: float) -> void:
	pass

func parse_line(line:String):
	var line_info = line.split(":")
	assert(len(line_info)>=2)
	return {
		"SpeakName":line_info[0],
		"dialog_lines":line_info[1]
	}
