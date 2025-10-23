extends StaticBody3D

var time: float = 0.0
var n: float = 0.5


func _process(delta):
	time += delta
	n = lerp(n, 2.0, 1 * delta)
	$Sprite3D.scale = Vector3(4.0, 0, 4.0) + Vector3(
		sin(time * n) * 0.5,
		1,
		sin(time * n / 2) * 0.5
	)

func touched():
	Global.touchedslimes -= 1
	n += randf_range(10.0, 12.5)
