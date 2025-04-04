extends CharacterBody2D

var health = 3
var strength = 1
var grace = 1
var power = 1
var control = 1
var defense = 1
@onready var player = get_node("/root/Game/Player")
func _ready() -> void:
	$%Slime.play_walk()

func _physics_process(delta: float) -> void:
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*300
	move_and_slide()
	#if(velocity.length() > 0):
		#$Slime.play_walk_animation()
	#else:
		#$Slime.play_idle_animation()
		
func take_damage(damage):
	#Later take in type to alter damage as well as defense
	health-=damage
	$%Slime.play_hurt()
	if(health == 0):
		#Hides death.
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()
	
