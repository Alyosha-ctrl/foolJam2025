extends CharacterBody2D
var actor_type = "object_mine"

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
		if(entity.actor_type != "object_mine" and entity.has_method("take_damage")):
			entity.take_damage(damage, "true", pierce)


func _on_hit_box_body_entered(body: Node2D) -> void:
	if("strength" in body):
		take_damage(body.strength*5, "true", body.strength*2)
