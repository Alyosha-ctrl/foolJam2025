class_name LevelAudioNode extends Node2D

@export var lv1: AudioStreamPlayer
@export var lv2: AudioStreamPlayer
@export var lv3: AudioStreamPlayer
@export var lv4: AudioStreamPlayer
@export var lv5: AudioStreamPlayer
@export var lv6: AudioStreamPlayer

func play_level_up_sound(level_class: int) -> void:
	match level_class:
		0:
			lv1.play()
		1:
			lv2.play()
		2:
			lv3.play()
		3:
			lv4.play()
		4:
			lv5.play()
		5:
			lv6.play()
		_:
			lv6.play()
