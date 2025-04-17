extends Area2D


@onready var caster = get_parent()
var type : String = "ranged"
var element : String = "creation"
var modifier : String = "auto_aim"
var action : String = "shoot"

var time : float = 0.0

var level:int=1
var cooldown : float = .5
var high_cooldown:float = .5
var cost : float = 0
var value : float = 5.0
var pierce : float = 1
var wait_time : float = cooldown
var stat_dist : Dictionary = {"cooldown": 1, "cost":5, "value":5, "pierce":1, "wait_time":.5}
	
func set_cooldown():
	cooldown = high_cooldown-(caster.control*stat_dist["cooldown"]/9.9)
	
	
func _ready() -> void:
	set_cooldown()

func _physics_process(delta: float) -> void:
	time+=delta
	if(!caster.actor_type == "mob"):
		var enemies_in_range = get_overlapping_bodies()
		if(enemies_in_range.size() > 0):
			var target = enemies_in_range.front()
			look_at(target.global_position)
		if(time >= cooldown):
			shoot()
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
	
func shoot():
	const BULLET = preload("res://bullet.tscn")
	var new_bullet = BULLET.instantiate()
	new_bullet.set_value(value_adder())
	new_bullet.technique = self
	new_bullet.pierce = pierce+(caster.strength/3)
	new_bullet.element = element
	new_bullet.global_position = $%shooting_point.global_position
	#Replace with the rotation aimed at the nearest enemy
	new_bullet.global_rotation = $%shooting_point.global_rotation
	$%shooting_point.add_child(new_bullet)

#MAYBE MAKE THIS MORE EFFICIENT
func set_level(level_num : int)->void:
	for i in range(level_num):
		level_up()


func level_up()->void:
	high_cooldown += stat_dist["cooldown"]
	print("Before Cooldown: " + str(high_cooldown))
	pierce += stat_dist["pierce"]
	value += stat_dist["value"]
	cost += stat_dist["cost"]
	wait_time += stat_dist["wait_time"]
	
	level += 1
	if(level%10 == 0):
		increase_stage()
	set_cooldown()
	print("Caster Control" + str(caster.control))
	print("After Cooldown: " + str(cooldown))

func increase_stage():
	var multiplier: int = (level/10+1)
	high_cooldown*=multiplier
	wait_time *= multiplier
	value *= multiplier
	cost *= multiplier
	pierce *= multiplier
	for key in stat_dist.keys():
		stat_dist[key] *= multiplier
