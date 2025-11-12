extends Area2D

@export var experience = 1

var spr_green = preload("res://Textures/Items/Gems/Gem_green.png")
var spr_blue= preload("res://Textures/Items/Gems/Gem_blue.png")
var spr_red = preload("res://Textures/Items/Gems/Gem_red.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $snd_collected

func _ready():
	if experience < 5:
		return
	elif experience < 25:
		sprite.texture = spr_blue
	else:
		sprite.texture = spr_red

func _physics_process(delta):
	if target != null:
		var direction = global_position.direction_to(target.global_position)
		var distance = global_position.distance_to(target.global_position)
		
		speed += 800 * delta
		speed = min(speed, 600)
		
		if distance > 10:
			global_position += direction * speed * delta
		else:
			global_position = target.global_position

func collect():
	sound.play()
	collision.call_deferred("set","disabled",true)
	sprite.visible = false
	return experience


func _on_snd_collected_finished():
	queue_free()
