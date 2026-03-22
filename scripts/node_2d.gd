extends Node2D

@onready var character = %CHARACTER
@onready var dialog_ui: Control = %"Dialog UI"
var dialog_index :int = 0

const dialog_lines : Array[String] = [
	"林峰:早上好哟，xx，该起床了",
	"杨坤:这现在几点啊",
	"勃林:zzz",
	"你:草，还要上早八服了，好困啊(下床)",
	"杨坤:(刷牙)",
	"勃林:(上半身裸露，眯着眼睛)",
	"旁白:你遵从这平日的习惯，刷牙洗脸，拉泡屎💩，出门，坐着 林峰 gege的电动车去上早八了",
	"旁白:你坐着他的车，能亲切的感受到他的体温，想起这个，你不时脸红了起来",
	"xx:我草(急刹车)",
	"旁白:由于惯性，你不得不抱住xx的腰",
	"你:(好温暖)",
	"xx:你没事吧",
	"你:没事(你脸红的急忙地松开了手)",
	"你:心想，哇，xx君好温柔哇",
	"旁白:到了教室，旁边正坐着的是杨坤，林峰，勃林，因为早上是水课，
	所以大家都在玩手机，你瞅了瞅杨坤，只见他打开了海岛奇兵，你看着他的侧颜，不由地轻哼了起来",
	"你:哇，杨坤哥好帅啊",
	"旁白:只见他手指轻轻一动，就把敌方给击破了，你又看了看勃林，拿着手机看着抖音，时不时憋着笑",
	"你:勃林哥是在做憋笑挑战吗",
]

func _ready() -> void:
	dialog_index = 0
	process_current_line()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("next_line"):
		if dialog_index < len(dialog_lines) - 1:
			dialog_index +=1
			process_current_line()

func parse_line(line:String):
	var line_info = line.split(":")
	assert(len(line_info)>=2)
	return {
		"speaker_name":line_info[0],
		"dialog_line":line_info[1]
	}

func process_current_line():
	var line = dialog_lines[dialog_index]
	var line_info = parse_line(line)
	dialog_ui.speaker_name.text = line_info["speaker_name"]
	dialog_ui.dialog_line.text = line_info["dialog_line"]
	character.change_character(line_info["speaker_name"])
