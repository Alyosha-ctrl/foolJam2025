extends Node2D


func _ready():
	physics_interpolation_mode = Node.PHYSICS_INTERPOLATION_MODE_OFF
	%Smoke.material.set_shader_parameter("texture_offset", Vector2(randfn(0.0, 1.0), randfn(0.0, 1.0)))
	%AnimationPlayer.play("explosion")
	await %AnimationPlayer.animation_finished
	queue_free()
