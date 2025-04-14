extends CharacterBody2D

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
const speed_multiplier = 600
var speed : float = calculate_speed()
var zoom_cap : float = .36
#var zoom_multiplier = 1/(speed/speed_multiplier)
func calculate_speed():
	return (speed_multiplier*log((grace/10)+2))

func set_speed(new_speed):
	speed = new_speed
	var new_zoom = 1/(speed/speed_multiplier)
	print("New Zoom")
	print(new_zoom)
	if(new_zoom <= zoom_cap):
		new_zoom = zoom_cap
	%Camera2D.zoom = Vector2(1,1)*new_zoom
	#emit_signal("changed_speed")
	
func _ready() -> void:
	set_speed(speed)

func _physics_process(delta: float) -> void:
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction*speed
	move_and_slide()

func take_damage(damage, element):
	#Later take in type to alter damage as well as defense
	#Need to know how to do this in accordance to time.
	damage -= defense
	if(damage <= 0):
		damage = 1
	health-=damage
	%ProgressBar.value = 100*(health/max_health)
	if(health <= 0):
		#Hides death.
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		death.emit()
		
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
	set_speed(calculate_speed())
	%ProgressBar.value = 100*(health/max_health)
	
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
		
	
