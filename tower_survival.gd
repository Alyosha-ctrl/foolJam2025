extends Node2D

var time = 0.0
var stat_mult = 1
var player_level = 1
var overall_stats = 0
var level_time = 5

func _ready() -> void:
	get_tree().paused = false
	for i in range(5):
		spawn_mob()

func spawn_mob():
	#In the future this will also create the color of the mob
	#And it's random technique's
	var new_mob = preload("res://mob.tscn").instantiate()
	new_mob.add_stats(overall_stats)
	#Randomly create's the mob on a point along the path
	%PathFollow2D.progress_ratio = randf()
	new_mob.global_position = %PathFollow2D.global_position
	add_child(new_mob)
	
func spawn_object():
	#later will be a random object now is just a tree soo to be pillar.
	const PILLAR = preload("res://pillar.tscn")
	var new_object = PILLAR.instantiate()
	#Randomly create's the mob on a point along the path
	%PathFollow2D.progress_ratio = randf()
	new_object.global_position = %PathFollow2D.global_position
	add_child(new_object)

func level_up():
	if(int(round(time+1))%level_time == 0):
		print("Time Value")
		print(time)
		print("Stat Multiplier")
		print(stat_mult)
		print("Player Speed")
		print(%Player.calculate_speed())
		%Player.add_stats(stat_mult)
		stat_mult=stat_mult*2
		overall_stats += stat_mult
		time = 0
		player_level+=1

func _on_timer_timeout() -> void:
	#Randomly choose spawn_swarm, spawn_cluster, spawn_boss 
	#later once levels are implemented
	var max_entities = 750
	level_up()
	if(!(len(get_children()) > max_entities)):
		spawn_mob()
		spawn_object()
	else:
		print("More than " + str(max_entities) + " entities")
	time+=($Timer.wait_time)
	
	

func _on_player_death() -> void:
	%game_over_screen.visible = true
	
func _on_restart_button_button_down() -> void:
	%game_over_screen.visible = false
	get_tree().reload_current_scene()
	
func _on_player_changed_speed() -> void:
	#print((1+(%Player.calculate_speed())/1000))
	%Path2D.scale = %Path2D.scale*(1+(%Player.calculate_speed())/1000)
