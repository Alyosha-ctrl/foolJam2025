extends Area2D

@onready var player := get_node("/root/Game/Player")
@onready var sound := get_node("/root/Game/PickUp")
func _on_body_entered(body: Node2D) -> void:
	if(body == player):
		sound.play()
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		smoke.global_position = self.global_position
		smoke.scale *= .5
		get_parent().add_child(smoke)
		player.health += player.max_health/4
		queue_free()
