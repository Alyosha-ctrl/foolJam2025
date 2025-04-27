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
		
func set_exp_amount(newExp : float) -> void:
	exp_amount = newExp
	
		
