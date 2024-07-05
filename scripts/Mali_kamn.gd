extends Kamn # ker hočemo enake lastnosti kot je velik kamn ... to nastaviš ob kreaciji skriptra
class_name Mali_kamn

signal mali_kamn_dest


func _ready() -> void:
	
	$Sprite.modulate = Color(255, 255, 255, 0.007)
	
func _on_mali_kamn_area_entered(area: Area2D) -> void:
	
	if area is Metk:
		emit_signal("mali_kamn_dest")
		queue_free()
		area.queue_free()


