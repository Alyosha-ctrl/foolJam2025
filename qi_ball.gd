extends Area2D

var exp_amount = 1

@onready var player := get_node("/root/Game/Player")

func _on_body_entered(body: Node2D) -> void:
	if(body == player):
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		smoke.global_position = self.global_position
		smoke.scale *= .5
		get_parent().add_child(smoke)
		player.add_exp(exp_amount)
		queue_free()
		
func set_exp_amount(newExp):
	exp_amount = newExp
	#Code that would be helpful, but might impact performance
	%exp_amount_text.text = str(exp_amount)
	if(exp_amount >= 100):
		%Octogan.scale = Vector2(2,2)
	elif(exp_amount >= 1000):
		%Octogan.scale = Vector2(3,3)
		%Grab_Area.scale = Vector2(2,2)
	elif(exp_amount >= 10000):
		%Octogan.scale = Vector2(3.5,3.5)
		%Grab_Area.scale = Vector2(2.5,2.5)
	elif(exp_amount >= 100000):
		%Octogan.scale = Vector2(4,4)
		%Grab_Area.scale = Vector2(3,3)
	elif(exp_amount >= 1000000):
		%Octogan.scale = Vector2(4.5,4.5)
		%Grab_Area.scale = Vector2(3.5,3.5)
	elif(exp_amount >= 10000000):
		%Octogan.scale = Vector2(5,5)
		%Grab_Area.scale = Vector2(4,4)
	
		
