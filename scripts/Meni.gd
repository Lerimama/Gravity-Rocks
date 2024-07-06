extends Node2D

onready var sound_naprej: AudioStreamPlayer = $sounds/naprej
onready var sound_nazaj: AudioStreamPlayer = $sounds/nazaj
onready var sound_fokus: AudioStreamPlayer = $sounds/fokus

onready var play_btn: Button = $Content/BtnContainer/PlayBtn
onready var highscores_btn: Button = $Content/BtnContainer2/HighscoresBtn
onready var exit_btn: Button = $Content/BtnContainer3/ExitBtn



func _ready() -> void:
	
	modulate.a = 0
	
	$Content/BtnContainer/Icon.hide()
	$Content/BtnContainer2/Icon.hide()
	$Content/BtnContainer3/Icon.hide()
	meni_in()
	
	
	# if html5
	#	html5_btns()



		
func meni_in():
	
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate:a", 1, 0.5)
	yield(fade_tween, "finished")	
		
	$Content/BtnContainer/PlayBtn.grab_focus()
	$Ogenj_anim.play()
	
	
func _on_PlayBtn_button_down() -> void:

	sound_naprej.play()
		
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().change_scene("res://scenes/Gejm.tscn")
	
	
func _on_HighscoresBtn_button_down() -> void:
	
	sound_naprej.play()
	
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().change_scene("res://scenes/Hajskor.tscn")

	
func _on_ExitBtn_button_down() -> void:
	
	sound_nazaj.play()
	
	var fade_tween = get_tree().create_tween()
	fade_tween.tween_property(self, "modulate:a", 0, 0.5)
	yield(fade_tween, "finished")
	get_tree().quit()


func html5_btns():
	
	# GO meni
	exit_btn.get_parent().hide()
	play_btn.focus_neighbour_top = "../../BtnContainer2/HighscoresBtn"
	highscores_btn.focus_neighbour_bottom = "../../BtnContainer/PlayBtn"	


# FOKUS


func _on_PlayBtn_focus_entered() -> void:
	
	sound_fokus.play()
	$Content/BtnContainer/Icon.show()
	
func _on_PlayBtn_focus_exited() -> void:
	$Content/BtnContainer/Icon.hide()
	
func _on_PlayBtn_mouse_entered() -> void:
	$Content/BtnContainer/PlayBtn.grab_focus()

	
func _on_HighscoresBtn_focus_entered() -> void:
	sound_fokus.play()
	$Content/BtnContainer2/Icon.show()

func _on_HighscoresBtn_focus_exited() -> void:
	$Content/BtnContainer2/Icon.hide()
	
func _on_HighscoresBtn_mouse_entered() -> void:
	$Content/BtnContainer2/HighscoresBtn.grab_focus()


func _on_ExitBtn_focus_entered() -> void:
	sound_fokus.play()
	$Content/BtnContainer3/Icon.show()

func _on_ExitBtn_focus_exited() -> void:
	$Content/BtnContainer3/Icon.hide()


func _on_ExitBtn_mouse_entered() -> void:
	$Content/BtnContainer3/ExitBtn.grab_focus()
