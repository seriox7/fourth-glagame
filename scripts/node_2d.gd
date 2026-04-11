extends Node2D

@onready var character_sprite: Node2D = %Character_sprite
@onready var dialog_ui: Control = %"Dialog UI"
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var buckground: TextureRect = %buckground

var is_choosing : bool = false
var chosen_target : String = "xx"
var dialog_index :int = 0

const BACKGROUND = {
	"教室":preload("res://assets/背景/3bad46d0d9a35c86c14cda8fbc4710c2.jpg"),
	"宿舍":preload("res://assets/背景/动漫卧室场景 (3)_爱给网_aigei_com.png"),
	"外面":preload("res://assets/背景/ffb5d42e1e5cacf909e838273917f807.jpg"),
	"马路":preload("res://assets/背景/2c6f731fe3a02dc0d39957c10d76cb45.jpg"),
	
}

const dialog_lines : Array[String] = [
	"宿舍：",
	"林峰：早上好哟，该起床了",
	"杨坤：这现在几点啊",
	"勃林：zzz",
	"你：草，还要上早八服了，好困啊(下床)",
	"杨坤：(刷牙)",
	"勃林：(上半身裸露，眯着眼睛)",
	"旁白：你遵从这平日的习惯，刷牙洗脸，拉泡屎💩，出门，但问题是你要坐谁的电动车去上早八呢",
	#下一场景 宿舍楼下
	"马路：",
	"选地点：来到宿舍楼下，三辆雅迪电动车停在你的面前，你决定——",
	"选择：坐勃林的车|坐林峰的车|坐杨坤的车",
	"旁白：你坐着他的车，能亲切的感受到他的体温，想起这个，你不时脸红了起来",
	"xx：我草(急刹车)",
	"旁白：由于惯性，你不得不抱住xx的腰",
	"你：(好温暖)",
	"xx：你没事吧",
	"你：没事(你脸红的急忙地松开了手)",
	"你：心想，哇，xx君好温柔哇",
	#下一场景 教室
	"教室：",
	"旁白：到了教室，旁边正坐着的是杨坤，林峰，勃林，因为早上是水课",
	"旁白：所以大家都在玩手机，你瞅了瞅杨坤，只见他打开了海岛奇兵，你看着他的侧颜，不由地轻哼了起来",
	"你：哇，杨坤哥好帅啊",
	"旁白：只见他手指轻轻一动，就把敌方给击破了",
	"旁白：杨坤自言自语道：",
	"杨坤：我要是蒋介石，海岛奇兵不简简单单，轻松拿下（杨坤傻傻笑道）",
	"旁白：你又看了看右边,只见林峰左眼看着黑板，右眼看着书",
	"旁白：你震惊道：这他妈诗人？这难道是传说中的左右脑互博？",
	"旁白：左右脑互博，指的是左脑操控左眼，右脑操控右眼",
	"旁白：他们分工明确，应然有序",
	"杨坤：这该不会激活了系统吧？",
	"旁白：众人已然被林峰的骚操作惊呆，这难道是学神附体了嘛",
	"旁白：老师看到林峰看似发呆，又诺似认真听讲，老师便想考考他",
	"旁白：来，我来抽个人，就这第三排，第四个，来，这道题怎么写",
	"旁白：林峰不屑的说到：",
	"林峰：这种垃圾题还敢点我？我看你是有眼不识泰山！",
	"旁白：只见林峰左右眼分叉，又两眼一闭",
	"林峰：这道题选A",
	"旁白：众人哈哈大笑，而只有你知道，事情没这么简单",
	"旁白：老师无奈的说到，这道题选B，林峰同学记得认真听讲哦",
	"林峰：(自言自语道)我要是选道了正常选项，你们还会把我当常人看吗？(林峰不屑的说到)",
	"旁白：你总感觉漏了一个人",
	"旁白：你又看了看杨坤旁边，勃林拿着手机看抖音，时不时憋着笑",
	"你：勃林哥是在做憋笑挑战吗",
	"旁白：（仍在憋笑，但似乎憋不住了，只见他下体猛然一抽？）",
	"勃林：啊~舒服了",
	"你：？？？？？？？？？？？？",
	"柏林：没什么，就是看手机的时候，看到杨坤的白袜子，太骚了，没忍住",
	"杨坤：？？？？？？？？？？？",
	"林峰：？？？？？？？？？？？(两眼聚在一起，像斗鸡眼)？？？？？？？",
	"旁白：众人：？？？？？？？",
	"旁白：老师：？？？？？？？？,同学们，课就先上到这，你们好自为之",
	"勃林：对了，杨坤，你记得去洗一下袜子，别问我为什么",
	"外面：",
	"旁白：竟然被柏林的骚操作，强制下课了，你们依次去吃了食堂，刚好下午没课，你决定跟谁去约会",
	"选伴侣：杨坤|勃林|林峰",
]

func _ready() -> void:
	dialog_ui.text_animation_done.connect(on_text_animation_done)
	dialog_index = 0
	process_current_line()
	#连接
	dialog_ui.button.pressed.connect(on_button_press)
	dialog_ui.button_2.pressed.connect(on_button2_press)
	dialog_ui.button_3.pressed.connect(on_button3_press)

func _input(event: InputEvent) -> void:
	if is_choosing:
		return
	if event.is_action_pressed("next_line"):
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(dialog_lines) - 1:
				dialog_index +=1
				process_current_line()

func parse_line(line:String):
	var line_info = line.split("：")
	assert(len(line_info)>=2)
	return {
		"speaker_name":line_info[0],
		"dialog_line":line_info[1]
	}

func process_current_line():
	var line = dialog_lines[dialog_index]
	var line_info = parse_line(line)
	var raw_speaker = line_info["speaker_name"]
	var raw_dialog  = line_info["dialog_line"]
	if raw_speaker == "选择":
		is_choosing = true
		var options = raw_dialog.split("|")
		dialog_ui.show_choices(options[0],options[1],options[2])
	var final_speaker = raw_speaker.replace("xx",chosen_target)
	var final_dialog = raw_dialog.replace("xx",chosen_target)
	dialog_ui.speaker_name.text = final_speaker
	dialog_ui.dialog_line.text = final_dialog
	character_sprite.change_character(final_speaker)
	if raw_speaker == "宿舍":
		buckground.texture = BACKGROUND[raw_speaker]
	if raw_speaker == "教室":
		buckground.texture = BACKGROUND[raw_speaker]
	if raw_speaker == "外面":
		buckground.texture = BACKGROUND[raw_speaker]
	if raw_speaker == "马路":
		buckground.texture = BACKGROUND[raw_speaker]
	
	
	

func on_text_animation_done():
	character_sprite.play_idle_animation()
	
func on_button_press():
	chosen_target = "勃林"
	after_choice()
	
func on_button2_press():
	chosen_target = "林峰"
	after_choice()
	
func on_button3_press():
	chosen_target = "杨坤"
	after_choice()
	
func after_choice():
	is_choosing = false
	dialog_ui.hide_choices()
	dialog_index += 1
	process_current_line()
