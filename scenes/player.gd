extends CharacterBody2D

@export var bullet: PackedScene = preload("res://scenes/bullet.tscn")
@export var player_animation : AnimatedSprite2D
@export var weapon_sprite : Sprite2D


var SPEED := 200.0
var JUMP_VELOCITY := 500.0

var gravity := 400.0
var bullet_velocity := 600.0


func _ready() -> void:
	pass
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if !event.is_pressed(): return
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			bullet_velocity += 20
			bullet_velocity = clamp(bullet_velocity, 100, 1500)
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			bullet_velocity -= 20
			bullet_velocity = clamp(bullet_velocity, 100, 1500)

func _process(delta: float) -> void:
	$RotPoint.look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("shoot"):
		var b = bullet.instantiate()
		get_parent().add_child(b)
		b.transform = $RotPoint/ShootPoint.global_transform
		b.velocity = b.transform.x * bullet_velocity
		b.gravity = gravity
	
	_animation()
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
		player_animation.play("jump")
	
	print(is_on_floor())
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	

func _animation():
	if is_on_floor():
		if velocity.x != 0:
			player_animation.play("walking")
		else:
			player_animation.play("default")

	if weapon_sprite.global_rotation_degrees > -90 && weapon_sprite.global_rotation_degrees < 90:
		weapon_sprite.scale.y = 0.2
		player_animation.flip_h = false
	else:
		weapon_sprite.scale.y = -0.2
		player_animation.flip_h = true
