extends Node3D

@export var effecttexture: Texture
@export var scaletexture: Vector2 = Vector2(0.25, 0.25)
@export var amounttexture: int = 16
@export var coloreffect: Color = Color(1.0, 1.0, 1.0)


func _ready() -> void:
	seteffect(effecttexture, scaletexture, amounttexture, coloreffect)
	#$GPUParticles3D.emitting

func seteffect(neffecttexture, nscaletexture, namounttexture, ncoloreffect):
	if $GPUParticles3D.draw_pass_1.material:
		$GPUParticles3D.draw_pass_1.material.albedo_texture = neffecttexture
		$GPUParticles3D.draw_pass_1.size = nscaletexture
		$GPUParticles3D.amount = namounttexture
		$GPUParticles3D2.amount = namounttexture / 2
		$GPUParticles3D2.draw_pass_1.material.albedo_color = ncoloreffect

func play():
	#$GPUParticles3D.emitting = true
	if Global.settings["effects"]:
		$GPUParticles3D.restart()
		$GPUParticles3D2.restart()
