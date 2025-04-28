extends Node2D


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://tower_survival.tscn")


func _on_credits_button_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/credits.tscn")



func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_gameplay_tips_pressed() -> void:
	get_tree().change_scene_to_file("res://main_menu/tips_menu.tscn")
