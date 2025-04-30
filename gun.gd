extends Area2D


var caster
var type : String = "ranged"
var element : String = "creation"
var modifier : String = "quick"
var action : String = "shoot"

var ranged_action_list : Dictionary = {"shoot":"A simple triangle set out to slice foes, it is cheap and cast quickly but it is weak and has no special properties",
	"wave":"A simple large projectile that scythes through enemies, it is powerful but expensive and slow"
}

var total_action_list : Dictionary = {
	"shoot":"A simple triangle set out to slice foes, it is cheap and cast quickly but it is weak and has no special properties",
	"wave":"A simple large projectile that scythes through enemies, it is powerful but expensive and slow",
	"heal_bullet":"A simple sphere set out to heal injuries, it is powerful and its powers to heal rare, but it has a very long cooldown, and has an extreme expense"
}

var total_modifier_list = ["cheap", "auto_aim", "quick", "self", "powerful"]

var technique_num : String = "technique0"
var active : bool = true
var time : float = 0.0

var level:int=1

var cooldown : float = 1
var cost : float = 5
var high_cost : float = cost
var value : float = 5.0
var pierce : float = 1
var wait_time : float = cooldown/2
var original_size := get_size_from_action()
var size := original_size

var stat_dist : Dictionary = {"cost":5, "value":5, "pierce":1}
var original: float= .5

func _ready() -> void:
	set_up()
	
func set_up():
	if(action == "wave"):
		original = 3.0
		value = 15
		cost = 25
		type = "ranged"
	elif(action== "shoot"):
		original = .3
		value = 10
		cost = 15
		type = "ranged"
	elif(action == "heal_bullet"):
		original = 10
		value = 10
		cost = 30
		type = "support"
	elif(action == "heal_wave"):
		original = 15
		value = 15
		cost = 45
		type = "support"
	elif(action == "dash"):
		original = 3
		value = 5
		cost = 25
		type = "melee"
		
	if(modifier == "powerful"):
		original *= 1.15
		value = value * 1.3
		stat_dist["value"] = stat_dist["value"]*1.3
	elif(modifier == "large"):
		original_size += 500
	elif(modifier == "quick"):
		original *= .7
		cost = cost*1.15
		stat_dist["cost"] = stat_dist["cost"]*1.15
	elif(modifier == "cheap"):
		value = value *.85
		stat_dist["value"] = stat_dist["value"]*.85
		cost = cost*.7
		stat_dist["cost"] = stat_dist["cost"]*.7
	elif(modifier == "self"):
		value = value * 1.3
		stat_dist["value"] = stat_dist["value"]*1.3
	
func get_random_ranged_technique():
	action = ranged_action_list.keys()[randi_range(0, ranged_action_list.keys().size())]
	modifier = total_modifier_list[randi_range(0, total_modifier_list.size())]
	set_up()
	
func get_random_technique():
	action = total_action_list.keys()[randi_range(0, total_action_list.keys().size())]
	modifier = total_modifier_list[randi_range(0, total_modifier_list.size())]
	set_up()

func get_size_from_action() -> float:
	if(action == "shoot"):
		return 1000.0
	elif(action == "wave"):
		return 500.0
	elif(action == "blast"):
		return 1500.0
	else:
		return 1000.0
		
func set_size():
	size = original_size * (1+log(caster.power)*original_size/1000)
	
func get_scale_multiplier():
	return (1+((log(caster.power)/2.3)*(original_size/1000)))

func set_cooldown():
	cooldown = original - log(caster.control)*(original/10)
	
func set_wait_time() ->void :
	wait_time = (original - log(caster.grace)*(original/10))/2
	
func set_cost():
	cost = high_cost - log(caster.defense)*(stat_dist["cost"]/10)

func _physics_process(delta: float) -> void:
	time+=delta
	if (Input.is_action_just_pressed(technique_num) and active == true):
		active = false
	elif(Input.is_action_just_pressed(technique_num)):
		active = true
		
	if(active):
		if(modifier == "auto_aim"):
			if(!caster.actor_type == "mob"):
				var enemies_in_range = get_overlapping_bodies()
				if(enemies_in_range.size() > 0):
					var target = enemies_in_range.front()
					look_at(target.global_position)
				if(time >= cooldown):
					if(action == "shoot"):
						shoot()
					elif(action == "wave"):
						wave()
					elif(action == "heal_bullet"):
						heal_bullet()
					time-= cooldown
		elif(modifier == "self"):
			look_at(caster.global_position)
			if(time >= cooldown):
					if(action == "shoot"):
						shoot()
					elif(action == "wave"):
						wave()
					elif(action == "heal_bullet"):
						heal_bullet()
					time -= cooldown
		elif (type == "ranged" and caster.actor_type == "mob"):
			#var entities_in_range = get_overlapping_bodies()
			#look_at(caster.player.global_position)
			var angle = (caster.player.global_position - self.global_position).angle()
			self.global_rotation = lerp_angle(self.global_rotation, angle, delta*.5)
			if(time >= cooldown):
				if(action == "shoot"):
					shoot()
				elif(action == "wave"):
					wave()
				elif(action == "heal_bullet"):
						heal_bullet()
				time -= cooldown
		elif(type == "ranged" and caster.actor_type == "player"):
			look_at(get_global_mouse_position())
			if(time >= cooldown 
			#and Input.is_action_pressed(technique_num)
			):
				if(action == "shoot"):
					shoot()
				elif(action == "wave"):
					wave()
				elif(action == "heal_bullet"):
						heal_bullet()
				time -= cooldown
		
				
				
		
		
func value_adder():
	var adder = 0
	if(type == "ranged"):
		adder += caster.power + caster.control*.5
	elif(type == "melee"):
		adder += caster.strength + caster.grace*.5
	#Remember to add one more in here to accomodate for the Dextrous melee trait.
	elif(type == "support"):
		adder += caster.control + caster.power*.5
	return value + adder
	
func remove_qi() -> bool:
	var end_qi : float = caster.qi-cost
	#MAKE A NOTIFICATION/sound IN THE FUTURE TO SHOW NO QI
	if(end_qi <= 0.0):
		caster.qi = 0
		if(caster.has_method("set_qi_bar")):
			caster.set_qi_bar()
		return false
	caster.qi = end_qi
	if(caster.has_method("set_qi_bar")):
		caster.set_qi_bar()
	return true
	
	
func shoot():
	if(!remove_qi()):
		return;
	const BULLET = preload("res://bullet.tscn")
	await get_tree().create_timer(wait_time).timeout
	var new_bullet = BULLET.instantiate()
	new_bullet.set_value(value_adder())
	new_bullet.technique = self
	new_bullet.technique_size = size
	new_bullet.speed = size
	new_bullet.pierce = pierce+(caster.strength/3)
	new_bullet.element = element
	new_bullet.global_position = $%shooting_point.global_position
	#Replace with the rotation aimed at the nearest enemy
	new_bullet.global_rotation = $%shooting_point.global_rotation
	
	$%shooting_point.add_child(new_bullet)
	
func wave():
	if(!remove_qi()):
		return;
	const WAVE = preload("res://wave.tscn")
	await get_tree().create_timer(wait_time).timeout
	var new_bullet = WAVE.instantiate()
	new_bullet.set_value(value_adder())
	new_bullet.technique = self
	new_bullet.technique_size = size
	new_bullet.speed = size*2
	new_bullet.pierce = pierce+(caster.strength/3)
	new_bullet.element = element
	new_bullet.scale = Vector2(1,1)*get_scale_multiplier()
	new_bullet.global_position = $%shooting_point.global_position
	#Replace with the rotation aimed at the nearest enemy
	new_bullet.global_rotation = $%shooting_point.global_rotation
	
	$%shooting_point.add_child(new_bullet)
	
func heal_bullet():
	if(!remove_qi()):
		return;
	const BULLET = preload("res://healing_bullet.tscn")
	await get_tree().create_timer(wait_time).timeout
	var new_bullet = BULLET.instantiate()
	new_bullet.set_value(value_adder())
	new_bullet.technique = self
	new_bullet.technique_size = size
	new_bullet.speed = size
	new_bullet.pierce = pierce+(caster.strength/3)
	new_bullet.element = element
	new_bullet.global_position = $%shooting_point.global_position
	#Replace with the rotation aimed at the nearest enemy
	new_bullet.global_rotation = $%shooting_point.global_rotation
	
	$%shooting_point.add_child(new_bullet)

func dash():
	if(!remove_qi()):
		return;
	var dashValue = 1 + log(value_adder())/10
	print(dashValue)
	caster.dash(dashValue)
	

#MAYBE MAKE THIS MORE EFFICIENT
func set_level(level_num : int)->void:
	for i in range(level_num):
		level_up()


func level_up()->void:
	pierce += stat_dist["pierce"]
	value += stat_dist["value"]
	high_cost += stat_dist["cost"]
	
	level += 1
	if(level%10 == 0):
		increase_stage()
	set_cooldown()
	set_cost()
	set_wait_time()
	set_size()

func increase_stage():
	var multiplier: int = (level/10+1)
	wait_time *= multiplier
	value *= multiplier
	high_cost *= multiplier
	pierce *= multiplier
	for key in stat_dist.keys():
		stat_dist[key] *= multiplier
