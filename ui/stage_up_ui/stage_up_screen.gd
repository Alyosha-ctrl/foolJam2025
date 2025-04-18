class_name StageUpScreen extends Control

@export var primary_audio_node: PrimaryAudioNode
@export var old_stage_label: Label
@export var new_stage_label: Label


var old_stage_int: int = 0:
	set(new_value):
		old_stage_int = new_value
		old_stage_label.text = (str(old_stage_int) + " -> ")
var new_stage_int: int = 1:
	set(new_value):
		new_stage_int=new_value
		new_stage_label.text = str(new_stage_int)


func increment_stage() -> void:
	old_stage_int += 1
	new_stage_int += 1

func show_stage_screen() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = true
	get_tree().paused = true

func hide_stage_screen() -> void:
	self.process_mode = Node.PROCESS_MODE_DISABLED
	self.visible = false
	get_tree().paused = false

func play_stage_up_audio() -> void:
	primary_audio_node.stage_node.play_stage_up_sound()

func _on_continue_button_pressed() -> void:
	hide_stage_screen()
