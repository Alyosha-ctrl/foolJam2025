class_name LevelUpScreen extends Control

@export var player: CharacterBody2D
@export var primary_audio_node: PrimaryAudioNode
@export var stage_up_container: VBoxContainer
@export var stage_up_screen: StageUpScreen

@export var lv_old_label: Label
@export var lv_new_label: Label
@export var str_old_label: Label
@export var str_new_label: Label
@export var gra_old_label: Label
@export var gra_new_label: Label
@export var pow_old_label: Label
@export var pow_new_label: Label
@export var con_old_label: Label
@export var con_new_label: Label
@export var def_old_label: Label
@export var def_new_label: Label
@export var hp_old_label: Label
@export var hp_new_label: Label
@export var qi_old_label: Label
@export var qi_new_label: Label

var level: int:
	set(new_value):
		level = new_value
		lv_old_label.text = (str(level) + " -> ")
var strength: float:
	set(new_value):
		strength = new_value
		str_old_label.text = (str(strength) + " -> ")
var grace: float:
	set(new_value):
		grace = new_value
		gra_old_label.text = (str(grace) + " -> ")
var power: float:
	set(new_value):
		power = new_value
		pow_old_label.text = (str(power) + " -> ")
var control: float:
	set(new_value):
		control = new_value
		con_old_label.text = (str(control) + " -> ")
var defense: float:
	set(new_value):
		defense = new_value
		def_old_label.text = (str(defense) + " -> ")
var max_health: float:
	set(new_value):
		max_health = new_value
		hp_old_label.text = (str(max_health) + " -> ")
var max_qi: float:
	set(new_value):
		max_qi = new_value
		qi_old_label.text = (str(max_qi) + " -> ")
var new_level: int:
	set(new_value):
		new_level = new_value
		lv_new_label.text = (str(new_level))
var new_strength: float:
	set(new_value):
		new_strength = new_value
		str_new_label.text = (str(new_strength))
var new_grace: float:
	set(new_value):
		new_grace = new_value
		gra_new_label.text = (str(new_grace))
var new_power: float:
	set(new_value):
		new_power = new_value
		pow_new_label.text = (str(new_power))
var new_control: float:
	set(new_value):
		new_control = new_value
		con_new_label.text = (str(new_control))
var new_defense: float:
	set(new_value):
		new_defense = new_value
		def_new_label.text = (str(new_defense))
var new_max_health: float:
	set(new_value):
		new_max_health = new_value
		hp_new_label.text = (str(new_max_health))
var new_max_qi: float:
	set(new_value):
		new_max_qi = new_value
		qi_new_label.text = (str(new_max_qi))



func _ready() -> void:
	hide_lv_screen()
	self_modulate.a = 0


func player_val_to_new_stats() -> void:
	if(player.actor_type == "player"):
		new_level = player.level
		new_strength = player.strength
		new_grace = player.grace
		new_power = player.power
		new_control = player.control
		new_defense = player.defense
		new_max_health = player.max_health
		new_max_qi = player.max_qi

func player_val_to_old_stats() -> void:
	if(player.actor_type == "player"):
		level = player.level
		strength = player.strength
		grace = player.grace
		power = player.power
		control = player.control
		defense = player.defense
		max_health = player.max_health
		max_qi = player.max_qi

func play_level_up_audio() -> void:
	primary_audio_node.level_node.play_level_up_sound(0)

func hide_lv_screen() -> void:
	self.visible = false
	get_tree().paused = false

func show_lv_screen() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = true
	stage_up_container.visible = false
	get_tree().paused = true
	play_level_up_audio()

func show_stage_screen() -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = true
	stage_up_container.visible = true
	stage_up_screen.increment_stage()
	get_tree().paused = true
	primary_audio_node.stage_node.play_stage_up_sound()

func _on_continue_button_pressed() -> void:
	hide_lv_screen()
