extends CharacterBody2D

#How to use parent timers, and how to copy functions.
var strength : float = 1.0
var grace : float = 1
var power : float = 1.0
var control : float = 1.0
var defense : float = 1.0
var max_health : float = strength*25
var health : float = max_health*1
var max_qi : float = power*25
var qi : float = max_qi*1
var time: float = 0.0
const speed_multiplier: float = 300
@onready var player = get_node("/root/Game/Player")
@onready var game = get_node("/root/Game")
@onready var cooldown = %Timer.wait_time

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*(speed_multiplier*log((grace/10)+2))
	move_and_slide()
	
	if(time >= cooldown):
		var overlaps = %hurt_box.get_overlapping_bodies()
		if(player in overlaps):
			player.take_damage(strength, "bump")
		time = 0.0
		
		

func take_damage(damage, element):
	#Later take in type to alter damage as well as defense
	health-=damage
	if(health <= 0):
		#Hides death.
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()
		
	


func _on_timer_timeout() -> void:
	#Randomly choose spawn_swarm, spawn_cluster, spawn_boss 
	#later once levels are implemented
	time+=($Timer.wait_time)
	
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
