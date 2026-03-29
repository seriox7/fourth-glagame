extends Node2D
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

const CHARACTER_FRAMES = {
	"林峰":preload("res://resourse/林峰_sprite_frames.tres"),
	"杨坤":preload("res://resourse/杨坤_sprite_frames.tres"),
	"勃林":preload("res://resourse/勃林_sprite_frames.tres"),
	"你":preload("res://resourse/你_sprite_frames.tres"),
	"旁白":preload("res://resourse/旁白_sprite_frames.tres")
}

func _ready() -> void:
	pass

func change_character(character_name:String,is_talking : bool = true):
	sprite.sprite_frames = CHARACTER_FRAMES[character_name]
	if is_talking:
		sprite.play("speak")
	else:
		sprite.play("idle")

func play_idle_animation():
	sprite.play("idle")
