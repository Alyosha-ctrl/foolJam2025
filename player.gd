extends CharacterBody2D
@export var lvl_up_screen: LevelUpScreen

var actor_type : String = "player"

var stat_dist : float = 5
var level : int = 1

signal death
signal changed_speed
var strength : float = 1
var grace : float = 1
var power : float = 1.0
var control : float = 1.0
var defense : float = 1.0
var max_health : float = strength*25
var health : float = max_health*1
var max_qi : float = power*25
var qi : float = max_qi*1
var qi_regeneration : float = control*9
const speed_multiplier = 600
var speed : float = calculate_speed()
var zoom_cap : float = .36
var num_of_tech : int = 1
#var zoom_multiplier = 1/(speed/speed_multiplier)
func calculate_speed():
	return (speed_multiplier*log((grace/10)+2))

func set_speed(new_speed):
	speed = new_speed
	var new_zoom = 1/(speed/speed_multiplier)
	if(new_zoom <= zoom_cap):
		new_zoom = zoom_cap
	%Camera2D.zoom = Vector2(1,1)*new_zoom
	#emit_signal("changed_speed")
	
func set_qi_bar() -> void:
	%qi_bar.value = 100*(qi/max_qi)
	
func set_health_bar() -> void:
	%ProgressBar.value = 100*(health/max_health)
	
func set_qi_regeneration() -> void:
	qi_regeneration = control*9
	
func _ready() -> void:
	set_speed(speed)
	%Gun.caster = self

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction*speed
	move_and_slide()
	
	if Input.is_action_just_pressed("exit_game"):
		get_tree().quit()
	
	var overlaps = %hurt_box.get_overlapping_bodies()
	for entity in overlaps:
		entity.take_damage(strength*delta, "bump", strength*2)
			

func take_damage(damage, element, pierce):
	var defense_local = defense-pierce
	if(defense_local < 0):
		defense_local = 0
	damage -= defense_local
	if(damage <= 0):
		damage = 1
	health -= damage
	%ProgressBar.value = 100*(health/max_health)
	if(health <= 0):
		#Hides death.
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		death.emit()
		
		lvl_up_screen.process_mode = Node.PROCESS_MODE_DISABLED
		get_tree().paused = true
func multiply_stats(statMult):
	strength*=statMult
	grace*=statMult
	power*=statMult
	control*=statMult
	defense*=statMult
	max_health = strength*25
	health = max_health*1
	max_qi = power*25
	qi = max_qi*1
	set_qi_regeneration()
	set_speed(calculate_speed())
	%ProgressBar.value = 100*(health/max_health)
	set_qi_bar()
	
func add_stats(statMult):
	strength+=statMult
	grace+=statMult
	power+=statMult
	control+=statMult
	defense+=statMult
	max_health = strength*25
	health = max_health*1
	max_qi = power*25
	qi = max_qi*1
	set_speed(calculate_speed())
	%ProgressBar.value = 100*(health/max_health)
	
func level_up():
	lvl_up_screen.player_val_to_old_stats()
	
	add_stats(stat_dist)
	level += 1
	if(level%10 == 0):
		increase_stage()
	else:
		lvl_up_screen.show_lv_screen()
	
	lvl_up_screen.player_val_to_new_stats()
	%Gun.level_up()
  
	print("Level Up")
	print("Level: " + str(level))
		
func increase_stage():
	multiply_stats((level/10) + 1)
	#Multiplies the new stat distribution
	stat_dist*=(level/10) + 1
	
	lvl_up_screen.show_stage_screen()
	
	print("Stage Increased")
	const GUN = preload("res://gun.tscn")
	var new_gun = GUN.instantiate()
	new_gun.caster = self
	new_gun.set_level(level)
	if(num_of_tech == 1):
		%tech_position1.add_child(new_gun)
	elif(num_of_tech == 2):
		%tech_position2.add_child(new_gun)
	elif(num_of_tech == 3):
		%tech_position3.add_child(new_gun)
	elif(num_of_tech == 4):
		%tech_position4.add_child(new_gun)
	elif(num_of_tech == 5):
		%tech_position5.add_child(new_gun)
	elif(num_of_tech == 6):
		%tech_position6.add_child(new_gun)
	elif(num_of_tech == 7):
		%tech_position7.add_child(new_gun)
	elif(num_of_tech == 8):
		%tech_position8.add_child(new_gun)
	elif(num_of_tech == 9):
		%tech_position9.add_child(new_gun)
	num_of_tech +=1
	
		
	


func _on_timer_timeout() -> void:
	#Once per second regenerate qi, 
	#apply all buffs, and apply all debuffs
	qi += qi_regeneration
	
	#Go through the status list(currently non existant)
	
	set_qi_bar()
	set_health_bar()
