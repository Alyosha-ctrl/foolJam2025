extends Area2D

var technique = "null"

var travelled_disance = 0
var speed = 1000
var technique_size = 100000
var value = 0
var element = "creation"
var pierce = 0

func _physics_process(delta: float) -> void:
	#gives current direction of the bullet
	var direction = Vector2.RIGHT.rotated(rotation)
	
	position += direction*speed*delta
	travelled_disance += speed*delta
	
	if(travelled_disance > technique_size):
		queue_free()


func _on_body_entered(body: Node2D) -> void:
	#This will destroy the bullet for on hit ranges
	if(!("actor_type" in body and technique.caster.actor_type == body.actor_type)):
		queue_free()
		if body.has_method("take_damage"):
			#Later will pass in damage type
			body.take_damage(value, element, pierce)
	elif(!"actor_type" in body):
		queue_free()
		if body.has_method("take_damage"):
			#Later will pass in damage type
			body.take_damage(value, element, pierce)
		
	
func set_value(newValue):
	value = newValue
	
