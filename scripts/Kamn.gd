extends Area2D

class_name Kamn

var velocity = Vector2.ZERO
var smer_vrtenja : int
var hitrost_vrtenja = 5
var hit_number = 0

# custom signal
signal kamn_dest
signal kamn_hit


func _ready() -> void:
	randomize()
	var x = rand_range(-200,200)
	var y = rand_range(-200,200)
	velocity = Vector2(x, y)
	
	smer_vrtenja = 1 # rand_range(-10, 10)
	hitrost_vrtenja = rand_range(-3, 3)

func _process(delta: float) -> void:
	position += velocity * delta
	rotate(smer_vrtenja * hitrost_vrtenja * delta)
	wrap()
	
	if hit_number == 2:
		emit_signal("kamn_dest", global_position) # global_position nam da pozicijo, ko seje to zgodilo in jo da v var ob klicu signala
		queue_free() # zgine kamn

func wrap():
	if position.x < 0:
		position.x = 1280
	if position.x > 1280:
		position.x = 0
	if position.y < 0:
		position.y = 720
	if position.y > 720:
		position.y = 0


func _on_Kamn_area_entered(area: Area2D) -> void:
	
	if area is Metk:
		$Sprite.modulate = Color(255, 255, 255, 0.007)
		hit_number += 1
		area.queue_free()
