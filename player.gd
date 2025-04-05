extends CharacterBody2D

signal death
var strength = 1
var grace = 1
var power = 1
var control = 1
var defense = 1
var max_health = strength*25
var health = max_health*1

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction*600
	move_and_slide()
	
	#No longer relevant after player model replaced with nonogan
	#if(velocity.length() > 0):
		#$HappyBoo.play_walk_animation()
	#else:
		#$HappyBoo.play_idle_animation()
		
	var overlapping_mobs = %hurt_box.get_overlapping_bodies()
	if(overlapping_mobs.size() > 0):
		health -= overlapping_mobs.size() * delta * 5.0 #Temporary 5 will be replaced with a takeDamage function.
		%ProgressBar.value = 100*(health/max_health)
	
	if(health <= 0.0):
		death.emit()
		
	
