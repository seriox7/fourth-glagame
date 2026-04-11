extends Control

@onready var dialog_line: RichTextLabel = %Dialog_line
@onready var speaker_name: Label = %SpeakerName
@onready var choice_box: VBoxContainer = %ChoiceBox
@onready var button: Button = $Control2/ChoiceBox/Button
@onready var button_2: Button = $Control2/ChoiceBox/Button2
@onready var button_3: Button = $Control2/ChoiceBox/Button3


signal  text_animation_done

const  ANIMATION_SPEED : int = 30
var animate_text : bool = false
var current_visible_characters : int = 0

func show_choices(text1:String,text2:String,text3:String):
	choice_box.show()
	button.text = text1
	button_2.text = text2 
	button_3.text = text3

func hide_choices():
	choice_box.hide()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:	
	if animate_text:
		if dialog_line.visible_ratio < 1:
			dialog_line.visible_ratio += (1.0/dialog_line.text.length())*(ANIMATION_SPEED*delta)
		else:
			animate_text = false
			text_animation_done.emit()
			
func change_line(speaker: String,line: String):
	speaker_name.text = speaker
	current_visible_characters = 0
	dialog_line.text = line
	dialog_line.visible_characters = 0
	animate_text = true
	
func skip_text_animation():
	dialog_line.visible_ratio = 1
