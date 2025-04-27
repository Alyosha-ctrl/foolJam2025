extends Area2D


var caster
var type : String = "ranged"
var element : String = "creation"
var modifier : String = "auto_aim"
var action : String = "wave"

var time : float = 0.0

var level:int=1
var current_exp : int = 0
var exp_needed : int = 9

var cooldown : float = 1
var cost : float = 15
var high_cost : float = cost
var value : float = 5.0
var pierce : float = 1
var wait_time : float = cooldown/2
var original_size := get_size_from_action()
var size := original_size

var stat_dist : Dictionary = {"cost":15, "value":5, "pierce":1}
var original:= .5

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
				time = 0.0
		elif (type == "ranged" and caster.actor_type == "mob"):
			#var entities_in_range = get_overlapping_bodies()
			#look_at(caster.player.global_position)
			var angle = (caster.player.global_position - self.global_position).angle()
			self.global_rotation = lerp_angle(self.global_rotation, angle, delta*.5)
			if(time >= cooldown):
				shoot()
				time = 0.0
		
		
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
