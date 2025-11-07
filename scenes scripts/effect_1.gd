extends Node3D

@export var effecttexture: Texture
@export var scaletexture: Vector2 = Vector2(0.25, 0.25)
@export var amounttexture: int = 16


func _ready() -> void:
	if effecttexture and scaletexture:
		if $GPUParticles3D.draw_pass_1.material:
			$GPUParticles3D.draw_pass_1.material.albedo_texture = effecttexture
			$GPUParticles3D.draw_pass_1.size = scaletexture
			$GPUParticles3D.amount = amounttexture
	#$GPUParticles3D.emitting

func play():
	#$GPUParticles3D.emitting = true
	$GPUParticles3D.restart()
