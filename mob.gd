extends CharacterBody2D

var actor_type : String = "mob"
var stat_dist : float = 5
var level : int = 1

#How to use parent timers, and how to copy functions.
var strength : float = 1.0
var grace : float = 1
var power : float = 1.0
var control : float = 1.0
var defense : float = 1.0
var max_health : float = strength*15
var health : float = max_health*1
var max_qi : float = power*25
var qi : float = max_qi*1
var qi_regeneration : float = control*9
var time: float = 0.0
const speed_multiplier: float = 300
@onready var player := get_node("/root/Game/Player")
@onready var cooldown : float = %Timer.wait_time
	

func _physics_process(delta: float) -> void:
	var direction := global_position.direction_to(player.global_position)
	velocity = direction*(speed_multiplier*log((grace/10)+2))
	move_and_slide()
	
	if(time >= cooldown):
		var overlaps = %hurt_box.get_overlapping_bodies()
		if(player in overlaps):
			visible = true
			player.take_damage(strength, "bump", strength*2)
		time = 0.0
		
		

func take_damage(damage, element, pierce):
	#Later take in type to alter damage as well as defense
	var defense_local : float = defense-pierce
	if(defense_local <= 0):
		defense_local = 1
	damage -= defense_local
	if(damage <= 0):
		damage = 1
	health-=damage
	
	if(!element == "bump"):
		%damage_sound.pitch_scale = randf_range(.8,1.2)
		%damage_sound.play()
	if(health <= 0):
		#Hides death.
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		smoke.global_position = self.global_position
		get_parent().add_child(smoke)
		queue_free()
		
	


func _on_timer_timeout() -> void:
	#Randomly choose spawn_swarm, spawn_cluster, spawn_boss 
	#later once levels are implemented
	time+=($Timer.wait_time)
	if(time == 1):
		qi += qi_regeneration
	
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
		max_health = strength*15
		health = max_health*1
		max_qi = power*25
		qi = max_qi*1
		
func level_up():
	add_stats(stat_dist)
	level += 1
	if(level%10 == 0):
		increase_stage()
		
func increase_stage():
	multiply_stats((level/10) + 1)
	#Multiplies the new stat distribution
	stat_dist*=(level/10) + 1
	
#MAYBE MAKE THIS MORE EFFICIENT
func set_level(level_num : int):
	for i in range(level_num):
		level_up()
	


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	%border.visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	%border.visible = false
