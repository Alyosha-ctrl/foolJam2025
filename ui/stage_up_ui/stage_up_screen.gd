class_name StageUpScreen extends Control

@export var primary_audio_node: PrimaryAudioNode
@export var old_stage_label: Label
@export var new_stage_label: Label
@export var level_up_screen: LevelUpScreen

@export var str_label: Label
@export var gra_label: Label
@export var pow_label: Label
@export var con_label: Label
@export var def_label: Label
@export var hp_label: Label
@export var qi_label: Label
@export var qi_regen_label: Label

var stren: float:
	set(new_value):
		stren = new_value
		str_label.text = str(stren)
var grace: float:
	set(new_value):
		grace = new_value
		gra_label.text = str(grace)
var power: float:
	set(new_value):
		power = new_value
		pow_label.text = str(power)
var contr: float:
	set(new_value):
		contr = new_value
		con_label.text = str(contr)
var defen: float:
	set(new_value):
		defen = new_value
		def_label.text = str(defen)
var health: float:
	set(new_value):
		health = new_value
		hp_label.text = str(health)
var qi: float:
	set(new_value):
		qi = new_value
		qi_label.text = str(qi)
var qi_regen: float:
	set(new_value):
		qi_regen = new_value
		qi_regen_label.text = str(qi_regen)

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

func on_stat_changed() -> void:
	str_label.add_theme_color_override("font_color",level_up_screen.increased_color)
	gra_label.add_theme_color_override("font_color",level_up_screen.increased_color)
	pow_label.add_theme_color_override("font_color",level_up_screen.increased_color)
	con_label.add_theme_color_override("font_color",level_up_screen.increased_color)
	def_label.add_theme_color_override("font_color",level_up_screen.increased_color)
	hp_label.add_theme_color_override("font_color",level_up_screen.increased_color)
	qi_label.add_theme_color_override("font_color",level_up_screen.increased_color)
	qi_regen_label.add_theme_color_override("font_color",level_up_screen.increased_color)
	stren = level_up_screen.new_strength * ((float(level_up_screen.new_level)/10) + 1)
	grace = level_up_screen.new_grace * ((float(level_up_screen.new_level)/10) + 1)
	power = level_up_screen.new_power * ((float(level_up_screen.new_level)/10) + 1)
	contr = level_up_screen.new_control * ((float(level_up_screen.new_level)/10) + 1)
	defen = level_up_screen.new_defense * ((float(level_up_screen.new_level)/10) + 1)
	qi = power * 25
	health = stren * 25
	qi_regen = contr * 9
