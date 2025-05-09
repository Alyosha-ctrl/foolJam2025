extends StaticBody2D

func take_damage(damage, element, pierce):
	const SMOKE_SCENE = preload("res://smoke_explosion/smoke_explosion.tscn")
	var smoke = SMOKE_SCENE.instantiate()
	smoke.scale *= 2.5
	get_parent().add_child(smoke)
	smoke.global_position = global_position
	explode(damage, element, pierce)
	queue_free()
	
func explode(damage, element, pierce):
	var overlaps = %hurt_box.get_overlapping_bodies()
	for entity in overlaps:
		if(entity!=self):
			entity.take_damage(damage, "true", pierce)
	
