extends CharacterBody2D
@export var lvl_up_screen: LevelUpScreen

var actor_type : String = "player"
var can_dash : bool = true

var stat_dist : float = 5
var level : int = 1
var exp : float = 0
var exp_max : int = 9

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

var friction : float = .5

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
	
func set_health(newHealth : float) -> void:
	health = newHealth
	set_health_bar()
	
func add_health(addedHealth : float) -> void:
	health+=addedHealth
	if(health > max_health):
		health = max_health
	set_health_bar()
	
func set_health_bar() -> void:
	%health_bar.value = 100*(health/max_health)

func set_exp_bar() -> void:
	%experience_bar.max_value = exp_max
	%experience_bar.value = exp
	
func set_qi_regeneration() -> void:
	qi_regeneration = control*9
	
		
func add_exp(newExp : float):
	exp += newExp
	while(exp > exp_max):
		exp -= exp_max
		level_up()
		exp_max+=9*pow(level/10 +1, 2)
	set_exp_bar()
	
	
func _ready() -> void:
	set_speed(speed)
	%Gun.caster = self

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction*speed
	move_and_slide()
	
	if Input.is_action_just_pressed("dash") and can_dash:
		dash(1)
		can_dash = false
	
	
	
	if Input.is_action_just_pressed("exit_game"):
		get_tree().change_scene_to_file("res://main_menu/main_menu.tscn")
	
	var overlaps = %hurt_box.get_overlapping_bodies()
	for entity in overlaps:
		entity.take_damage((strength+grace/2)*delta, "bump", strength*2)
			

func dash(dashValue):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity += direction*(dashValue*(speed*5))
	velocity *= 1 - (friction*get_physics_process_delta_time())
	move_and_slide()

func take_damage(damage, element, pierce):
	var defense_local = defense-pierce
	if(defense_local < 0):
		defense_local = 0
	damage -= defense_local
	if(damage <= 0):
		damage = 1
	health -= damage
	%health_bar.value = 100*(health/max_health)
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
	%health_bar.value = 100*(health/max_health)
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
	%health_bar.value = 100*(health/max_health)

func reset_bars() -> void:
	health = max_health * 1
	qi = max_qi * 1
	set_health_bar()
	set_qi_bar()


func level_up():
	lvl_up_screen.player_val_to_old_stats()
	

	level += 1
	if(level%10 == 0):
		increase_stage()
	else:
		lvl_up_screen.show_lv_screen(stat_dist * 5)
	
	lvl_up_screen.player_val_to_new_stats()
	%Gun.level_up()

	print("Level Up")
	print("Level: " + str(level))
		
func increase_stage():
	# multiply_stats((level/10) + 1)
	#Multiplies the new stat distribution
	
	lvl_up_screen.show_stage_screen(stat_dist * 5)
	
	stat_dist*=(level/10) + 1
	exp_max *= pow((level/10) + 1, 2)

	print("Stage Increased")
	const GUN = preload("res://gun.tscn")
	var new_gun = GUN.instantiate()
	new_gun.caster = self
	new_gun.set_level(level)
	if(num_of_tech == 1):
		%tech_position1.add_child(new_gun)
		new_gun.technique_num = "technique1"
		new_gun.action = "wave"
	elif(num_of_tech == 2):
		%tech_position2.add_child(new_gun)
		new_gun.technique_num = "technique2"
	elif(num_of_tech == 3):
		%tech_position3.add_child(new_gun)
		new_gun.technique_num = "technique3"
	elif(num_of_tech == 4):
		%tech_position4.add_child(new_gun)
		new_gun.technique_num = "technique4"
	elif(num_of_tech == 5):
		%tech_position5.add_child(new_gun)
		new_gun.technique_num = "technique5"
	elif(num_of_tech == 6):
		%tech_position6.add_child(new_gun)
		new_gun.technique_num = "technique6"
	elif(num_of_tech == 7):
		%tech_position7.add_child(new_gun)
		new_gun.technique_num = "technique7"
	elif(num_of_tech == 8):
		%tech_position8.add_child(new_gun)
		new_gun.technique_num = "technique8"
	elif(num_of_tech == 9):
		%tech_position9.add_child(new_gun)
		new_gun.technique_num = "technique9"
	num_of_tech +=1
	
		
	


func _on_timer_timeout() -> void:
	#Once per second regenerate qi, 
	#apply all buffs, and apply all debuffs
	qi += control*9
	can_dash = true
	#Go through the status list(currently non existant)
	
	set_qi_bar()
	set_health_bar()
