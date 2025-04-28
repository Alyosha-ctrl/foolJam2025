extends StaticBody2D

const HEALTH_DROP = preload("res://health_drop.tscn")
func _ready() -> void:
	%ColorRect.visible = true

func take_damage(damage, element, pierce):
	if(element != "bump"):
		if((randi() % 10) > 7):
			var qi_ball = HEALTH_DROP.instantiate()
			qi_ball.global_position = global_position
			add_sibling(qi_ball)
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	%ColorRect.visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	%ColorRect.visible = false
