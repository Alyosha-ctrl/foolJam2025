extends StaticBody2D

func _ready() -> void:
	%ColorRect.visible = true

func take_damage(damage, element, pierce):
	if(element != "bump"):
		const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
		var smoke = SMOKE_SCENE.instantiate()
		get_parent().add_child(smoke)
		smoke.global_position = global_position
		queue_free()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	%ColorRect.visible = true


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	%ColorRect.visible = false
