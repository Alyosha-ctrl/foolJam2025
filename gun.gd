extends Area2D


@onready var caster = get_parent()

var cooldown : float = 0.5
var time : float = 0.0
var type : String = "ranged"
var element : String = "creation"
var cost : float = 0
var value : float = 5.0



func _physics_process(delta: float) -> void:
	var enemies_in_range = get_overlapping_bodies()
	if(enemies_in_range.size() > 0):
		var target = enemies_in_range.front()
		look_at(target.global_position)
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
	new_bullet.element = element
	new_bullet.global_position = $%shooting_point.global_position
	#Replace with the rotation aimed at the nearest enemy
	new_bullet.global_rotation = $%shooting_point.global_rotation
	$%shooting_point.add_child(new_bullet)

	
	
func _on_timer_timeout() -> void:
	time += %Timer.wait_time
