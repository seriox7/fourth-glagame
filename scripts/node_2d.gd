extends Node2D

@onready var character_sprite: Node2D = %Character_sprite
@onready var dialog_ui: Control = %"Dialog UI"
@onready var texture_rect: TextureRect = $CanvasLayer/TextureRect
@onready var buckground: TextureRect = %buckground

var is_choosing : bool = false
var chosen_target : String = "xx"
var current_question : String = ""
var dialog_index :int = 0
var current_dialog : Array[String] = []
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
	"你：??????????????????",
	"柏林：没什么，就是看手机的时候，看到杨坤的白袜子，太骚了，没忍住",
	"杨坤：???????????????",
	"林峰：????????????????????(两眼聚在一起，像斗鸡眼)??????????",
	"旁白：众人：??????????????????",
	"旁白：老师:????????????,同学们，课就先上到这，你们好自为之",
	"勃林：对了，杨坤，你记得去洗一下袜子，别问我为什么",
	"外面：",
	"旁白：竟然被柏林的骚操作，强制下课了，你们依次去吃了食堂，刚好下午没课，你决定跟谁去约会",
	"选伴侣：勃林|林峰|杨坤",
]
const dialog_yangkuen : Array[String] = [
	"你：杨坤，你打算下午去哪玩",
	"杨坤：我要去当个混子，我是混子，你和我去逛逛里不（山东话）",
	"你：好哇",
	"旁白：你们出了校门，来到街边",
	"杨坤：好了，就站在这里，等客人来",
	"你：？？？？，什么客人",
	"杨坤：就是有生理需求的",
	"你：？？？？不是说去逛街吗",
	"杨坤：我是乡下人，没有钱，需要先赚点钱，你懂的",
	"你：但谁会在白天站街哇，怎么光明正大",
	"旁白：很显然，警察也注意到这一点",
	"警察：喝~小子，干嘛呢",
	"杨坤：警察叔叔，我没钱，想站街挣点零花钱，通融一下",
	"警察：不管怎么说，你先跟我走一趟",
	"杨坤：饿啊~",
	"警察：饿就吃饭",
	"旁白：于是，你就被杨sb坑进了警局",
	"警察：你们先进去，待会联系你们家长",
	"你：啊？那可不行，可不能让我家长知道哇",
	"杨坤：（灵机一动）我从玩海岛奇兵的经验来看，我们要先把这手铐摘掉（看上了你的小发夹）",
	"你：你有什么主意吗",
	"杨坤：你先把头低下",
	"旁白：你把头低下，你能明显的感觉到杨坤在亲吻你的头",
	"杨坤：（杨坤示意你把嘴张开）",
	"你：你照做了，但杨坤突然亲吻你，你们的舌头在打转，哦，原来是先让你拿着",
	"杨坤：听着，我不是故意亲你的，我是先让你拿这啊（脸红的像个苹果）",
	"杨坤：听好，你开锁要先向上翘一下，然后......",
	"杨坤：你来试下吧",
	"旁白：你遵从着杨坤的教导。成功的把杨坤的手铐解开了",
	"杨坤：可以啊，看来你有成为我媳妇的潜质，不对，当我没说（杨坤尴尬地笑道）",
	"旁白：你不由的笑出了声",
	"旁白：你们用嘴交换发夹（虽然杨坤可以用手，但作者想这样写）",
	
	
]
const dialog_linfeng : Array[String] = [
"你：林峰，下午你有事吗，一起去哪玩玩",
"林峰：不好意思哇，我下午要去图书馆，你去吗",
"你：行吧，我跟你一起去",
"旁白：见林峰背着一大包书，你就知道，今天下午不简单",
"旁白：你们找了个位置坐了下来，随后林峰两眼分叉，快速地翻阅着书籍",
"你：(发着呆)这特么是人？",
"林峰：终于到这一天了",
"旁白：随后，林峰的额头上长出了第三只眼睛，一阵妖风随起，把旁边的书乱地到处都是",
"旁边一女生：你tm能不能小点声，我还要考研呢，信不信我把你挂小红书里",
"林峰：(闭上了第三只眼睛)(害羞了起来)不好意思啊，对不起",
"旁边一女生：哼~",
"林峰：我骗你的，哈哈哈",
"旁白：林峰向上一指，千万本书涌向那个女生，把她给撞出了窗外",
"旁白：",
]
const dialog_bolin : Array[String] = []
func _ready() -> void:
	current_dialog = dialog_lines
	dialog_ui.text_animation_done.connect(on_text_animation_done)
	dialog_index = 0
	
	#连接
	dialog_ui.button.pressed.connect(on_button_press)
	dialog_ui.button_2.pressed.connect(on_button2_press)
	dialog_ui.button_3.pressed.connect(on_button3_press)
	process_current_line()

func _unhandled_input(event: InputEvent) -> void:
	
	# 🛑 第一道防线：如果在选人，彻底锁死屏幕点击！
	# 此时玩家只能去点 UI 按钮，点屏幕没任何反应。
	if is_choosing:
		return 
		
	# 🎬 正常看剧情的逻辑（点屏幕或按空格）
	if event.is_action_pressed("next_line"):
		if dialog_ui.animate_text:
			dialog_ui.skip_text_animation()
		else:
			if dialog_index < len(current_dialog) - 1:
				dialog_index += 1
				process_current_line()

func parse_line(line:String):
	var line_info = line.split("：")
	assert(len(line_info)>=2)
	return {
		"speaker_name":line_info[0],
		"dialog_line":line_info[1]
	}

func process_current_line():
	var line = current_dialog[dialog_index]
	var line_info = parse_line(line)
	var raw_speaker = line_info["speaker_name"]
	var raw_dialog  = line_info["dialog_line"]
	if raw_speaker == "选择" or raw_speaker == "选伴侣":
		is_choosing = true
		var options = raw_dialog.split("|") 
		dialog_ui.show_choices(options[0], options[1], options[2])
		return
	var final_speaker = raw_speaker.replace("xx",chosen_target)
	var final_dialog = raw_dialog.replace("xx",chosen_target)
	
	dialog_ui.speaker_name.text = final_speaker
	dialog_ui.dialog_line.text = final_dialog
	character_sprite.change_character(final_speaker)
	if raw_speaker in BACKGROUND:
		buckground.texture = BACKGROUND[raw_speaker]
		dialog_index +=1
		process_current_line()
		return
	
	

func on_text_animation_done():
	character_sprite.play_idle_animation()
	
func on_button_press():
	if current_question == "选择":
		print("1111111111111")
		chosen_target = "勃林"
		dialog_index +=1
		after_choice()
	elif current_question == "选伴侣":
		print("2222222222222222")
		current_dialog = dialog_bolin
		dialog_index = 0
		
	
	
func on_button2_press():
	if current_question == "选择":
		print("1111111111111")
		chosen_target = "林峰"
		dialog_index +=1
		after_choice()
	elif current_question == "选伴侣":
		print("22222222222")
		current_dialog = dialog_linfeng
		dialog_index = 0
		
	
	
func on_button3_press():
	if current_question == "选择":
		print("1111111111111")
		chosen_target = "杨坤"
		dialog_index +=1
		after_choice()
	elif current_question == "选伴侣":
		print("222222222222")
		current_dialog = dialog_yangkuen
		dialog_index = 0
		
	
func after_choice():
	is_choosing = false
	dialog_ui.hide_choices()
	dialog_index += 1
	process_current_line()
