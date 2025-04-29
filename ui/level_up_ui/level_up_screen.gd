class_name LevelUpScreen extends Control

@export var player: CharacterBody2D
@export var primary_audio_node: PrimaryAudioNode
@export var stage_up_container: VBoxContainer
@export var stage_up_screen: StageUpScreen

@export var stat_point_label: Label
@export var increased_color: Color
@export var increase_text_field: TextEdit
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
@export var qi_regen_label: Label
@export var qi_new_regen_label: Label

var starting_stat_points: int
var amount_to_change: int = 1

var stat_points: int = 25:
	set(new_value):
		stat_points = new_value
		stat_point_label.text = ("Remaining stat points: " + str(stat_points))
		stage_up_screen.on_stat_changed()
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
var qi_regen: float:
	set(new_value):
		qi_regen = new_value
		qi_regen_label.text = (str(qi_regen) + " -> ")
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
var new_qi_regen: float:
	set(new_value):
		new_qi_regen = new_value
		qi_new_regen_label.text = (str(new_qi_regen))



func _ready() -> void:
	self.visible = false
	get_tree().paused = false
	self_modulate.a = 0

# func _process(_delta):
# 	if(stage_up_container.visible == false):
# 		stage_up_screen.on_stat_changed()

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
		new_qi_regen = player.qi_regeneration

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
		qi_regen = player.qi_regeneration

func set_player_stats() -> void:
	if(stage_up_container.visible == false):
		player.strength = new_strength
		player.grace = new_grace
		player.power = new_power
		player.control = new_control
		player.defense = new_defense
		player.max_health = new_max_health
		player.max_qi = new_max_qi
	else:
		player.strength = stage_up_screen.stren
		player.grace = stage_up_screen.grace
		player.power = stage_up_screen.power
		player.control = stage_up_screen.contr
		player.defense = stage_up_screen.defen
		player.max_health = stage_up_screen.health
		player.max_qi = stage_up_screen.qi

func play_level_up_audio() -> void:
	primary_audio_node.level_node.play_level_up_sound(0)

func hide_lv_screen() -> void:
	self.visible = false
	get_tree().paused = false
	set_player_stats()
	player.reset_bars()
	player.set_speed(player.calculate_speed())
	player.set_qi_regeneration()

func show_lv_screen(points_to_add: int) -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = true
	stage_up_container.visible = false
	
	starting_stat_points = points_to_add
	stat_points = starting_stat_points

	str_new_label.remove_theme_color_override("font_color")
	gra_new_label.remove_theme_color_override("font_color")
	pow_new_label.remove_theme_color_override("font_color")
	con_new_label.remove_theme_color_override("font_color")
	def_new_label.remove_theme_color_override("font_color")
	hp_new_label.remove_theme_color_override("font_color")
	qi_new_label.remove_theme_color_override("font_color")
	qi_new_regen_label.remove_theme_color_override("font_color")

	get_tree().paused = true
	play_level_up_audio()

func show_stage_screen(points_to_add: int) -> void:
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	self.visible = true
	stage_up_container.visible = true
	stage_up_screen.increment_stage()

	starting_stat_points = points_to_add
	stat_points = starting_stat_points

	str_new_label.remove_theme_color_override("font_color")
	gra_new_label.remove_theme_color_override("font_color")
	pow_new_label.remove_theme_color_override("font_color")
	con_new_label.remove_theme_color_override("font_color")
	def_new_label.remove_theme_color_override("font_color")
	hp_new_label.remove_theme_color_override("font_color")
	qi_new_label.remove_theme_color_override("font_color")
	qi_new_regen_label.remove_theme_color_override("font_color")
	
	get_tree().paused = true
	primary_audio_node.stage_node.play_stage_up_sound()


func _on_continue_button_pressed() -> void:
	if(stat_points == 0):
		hide_lv_screen()
		set_player_stats()


func update_hp_qi() -> void:
	new_max_qi = new_power * 25
	new_max_health = new_strength * 25
	new_qi_regen = new_control * 9

	if(new_max_qi > max_qi):
		qi_new_label.add_theme_color_override("font_color", increased_color)
	else:
		qi_new_label.remove_theme_color_override("font_color")
	
	if(new_max_health > max_health):
		hp_new_label.add_theme_color_override("font_color",increased_color)
	else:
		hp_new_label.remove_theme_color_override("font_color")
	
	if(new_qi_regen > qi_regen):
		qi_new_regen_label.add_theme_color_override("font_color",increased_color)
	else:
		qi_new_regen_label.remove_theme_color_override("font_color")



func limit_text_field() -> void:
	var amount_int: int
	amount_int = int(increase_text_field.text)
	if(amount_int > stat_points):
		amount_int = stat_points
	increase_text_field.text = (str(amount_int))
	increase_text_field.set_caret_column(str(increase_text_field.text).length())
	amount_to_change = amount_int

func _on_undo_str_pressed() -> void:
	if(new_strength != strength && amount_to_change <= (new_strength - strength)):
		new_strength -= amount_to_change
		stat_points += amount_to_change
	if(new_strength == strength):
		str_new_label.remove_theme_color_override("font_color")
	update_hp_qi()


func _on_add_str_pressed() -> void:
	if(stat_points >= 0  && amount_to_change <= stat_points):
		new_strength += amount_to_change
		stat_points -= amount_to_change
		str_new_label.add_theme_color_override("font_color",increased_color)
	update_hp_qi()


func _on_undo_gra_pressed() -> void:
	if(new_grace != grace && amount_to_change <= (new_grace - grace)):
		new_grace -= amount_to_change
		stat_points += amount_to_change
	if(new_grace == grace):
		gra_new_label.remove_theme_color_override("font_color")


func _on_add_gra_pressed() -> void:
	if(stat_points >= 0  && amount_to_change <= stat_points):
		new_grace += amount_to_change
		stat_points -= amount_to_change
		gra_new_label.add_theme_color_override("font_color",increased_color)


func _on_undo_pow_pressed() -> void:
	if(new_power != power && amount_to_change <= (new_power - power)):
		new_power -= amount_to_change
		stat_points += amount_to_change
	if(new_power == power):
		pow_new_label.remove_theme_color_override("font_color")
	update_hp_qi()


func _on_add_pow_pressed() -> void:
	if(stat_points >= 0  && amount_to_change <= stat_points):
		new_power += amount_to_change
		stat_points -= amount_to_change
		pow_new_label.add_theme_color_override("font_color",increased_color)
	update_hp_qi()

func _on_undo_con_pressed() -> void:
	if(new_control != control && amount_to_change <= (new_control - control)):
		new_control -= amount_to_change
		stat_points += amount_to_change
	if(new_control == control):
		con_new_label.remove_theme_color_override("font_color")
	update_hp_qi()

func _on_add_con_pressed() -> void:
	if(stat_points >= 0  && amount_to_change <= stat_points):
		new_control += amount_to_change
		stat_points -= amount_to_change
		con_new_label.add_theme_color_override("font_color",increased_color)
	update_hp_qi()


func _on_undo_def_pressed() -> void:
	if(new_defense != defense && amount_to_change <= (new_defense - defense)):
		new_defense -= amount_to_change
		stat_points += amount_to_change
	if(new_defense == defense):
		def_new_label.remove_theme_color_override("font_color")

func _on_add_def_pressed() -> void:
	if(stat_points >= 0  && amount_to_change <= stat_points):
		new_defense += amount_to_change
		stat_points -= amount_to_change
		def_new_label.add_theme_color_override("font_color",increased_color)


func _on_amount_text_field_text_changed() -> void:
	limit_text_field()
