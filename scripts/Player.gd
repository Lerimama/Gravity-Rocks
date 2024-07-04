extends Area2D

#class_name Player

signal raketa_dest

var rotation_dir
export (float) var rotation_speed = 4.1

var velocity : Vector2 # definiramo tip variable
var input_vector : Vector2 # ta vektor račun ali gre v rikver ali ne

export (int) var accelaration = 900
export (int) var max_speed = 700
export (float) var friction = 1.0 # med igro se določa v proccess

var velikost_ekrana = Vector2()

var shield_status := 1


func _ready() -> void:
	
	hide()
	velikost_ekrana = get_viewport_rect().size
	position = velikost_ekrana / 2

func _process(delta: float) -> void:
	
	rotation_dir = Input.get_axis("ui_left", "ui_right")
	rotate(rotation_dir * delta * rotation_speed)
	
#	input_vector.x = Input.get_action_strength("ui_up") - Input.get_action_strength("ui_down")
	input_vector.x = Input.get_action_strength("ui_up")
	rotation_dir = 0
	
	# BREMZA
	if Input.get_action_strength("ui_down") ==  1:
		friction += 0.1
	else:
		friction = 0.5
	
	velocity += Vector2(input_vector.x * accelaration * delta, 0).rotated(rotation)
	velocity.x = clamp(velocity.x, -max_speed, max_speed)
	velocity.y = clamp(velocity.y, -max_speed, max_speed)
#	velocity.x = clamp(velocity.x, 0, max_speed) # raketa pač ne more v rikverc
#	velocity.y = clamp(velocity.y, 0, max_speed)
	
	if input_vector.x == 0 && velocity != Vector2.ZERO: # če je vnos vektorja 0, potem apliciriaj trenje ... in če raketa niže pri miru
		velocity = lerp(velocity, Vector2.ZERO, friction * delta) # interpoliramo(motion tween kao) od trenutne hitrosti, do 0
		if abs(velocity.x) <= 0.1: # more čekirati absolutna vrednost, ker je lahko tudi negaditvna
			velocity.x = 0
		if abs(velocity.y) <= 0.1:
			velocity.y = 0
	
	if Input.get_action_strength("ui_up") > 0:
		$Ogenj_anim.play("ogenj_gasa")
	else:
		$Ogenj_anim.play("ogenj_bremza")

	if Input.is_action_just_pressed("ui_up") == true:
		 $engin.play()
	elif Input.is_action_just_released("ui_up") == true:
		$engin.stop()
		
	if shield_status == 1:
		$Shield_anim.play("shield_on")
	else:
		$Shield_anim.play("shield_off")	

	position += velocity * delta
	wrap()

func wrap():
	if position.x < 0:
		position.x = velikost_ekrana.x
	if position.x > velikost_ekrana.x:
		position.x = 0
	if position.y < 0:
		position.y = velikost_ekrana.y
	if position.y > velikost_ekrana.y:
		position.y = 0


func _on_Player_area_entered(area: Area2D) -> void:
	
	if shield_status == 0 && is_visible_in_tree() == true:
		if area is Kamn:
			emit_signal("raketa_dest", global_position) # global_position nam da pozicijo, ko seje to zgodilo in jo da v var ob klicu signala

func _on_ShieldTime_timeout() -> void:
	shield_status = 0
