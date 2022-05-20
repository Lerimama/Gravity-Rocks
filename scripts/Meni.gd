extends Node2D

func _ready() -> void:
	$Ogenj_anim.play()

func _on_Play_btn_button_down() -> void:
	get_tree().change_scene("res://scenes/Gejm.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_released("ui_accept"):
		get_tree().change_scene("res://scenes/Gejm.tscn")
		
	if Input.is_action_just_released("ui_cancel"):
		get_tree().change_scene("res://scenes/Hajskor.tscn")
