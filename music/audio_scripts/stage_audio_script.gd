class_name StageAudioNode extends Node2D

@export var stage_up: AudioStreamPlayer

func play_stage_up_sound() -> void:
	stage_up.play()
