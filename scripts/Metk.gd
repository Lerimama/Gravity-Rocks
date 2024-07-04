extends Area2D
class_name Metk # class name, da ga lahko kličemo ,,, je po konvenciji

signal metek_zadetek

export var hitrost = 7200
export var smer = Vector2()


func _process(delta: float) -> void:
	position += transform.x * hitrost * delta
	$AnimatedSprite.play("shoot_anim")


func _on_DometMetka_timeout() -> void:
	
	queue_free()


func _on_metk_area_entered(area: Area2D) -> void:
	
	emit_signal("metek_zadetek", global_position, global_rotation) # global_position nam da pozicijo, ko seje to zgodilo in jo da v var ob klicu signala
	queue_free()
