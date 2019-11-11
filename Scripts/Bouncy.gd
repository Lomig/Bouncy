extends KinematicBody2D

const GRAVITY = 5000
const THETA = deg2rad(45)

var acceleration
var velocity

var bounce
var move
var wall
var roof
var falling
var jump_after_bounce
var jump

var collision

var key_registered
var move_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	acceleration = Vector2(0, GRAVITY)
	velocity = Vector2()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if bounce:
		# velocity = - velocity -- Does not work, Bouncy keeps bouncing higher than previously
		velocity = Vector2(0, -1000)
		bounce = false
	elif move:
		var cell_width = 169 # Should be 180 / Don't know why it works better
		var direction = (cell_width / cos(THETA)) * sqrt(GRAVITY / (2 * (cell_width * tan(THETA))))

		velocity.x = move_direction * direction *cos(THETA)
		velocity.y = - direction * sin(THETA)
		move = false
	elif wall:
		# velocity = - velocity -- Same issue, Bouncy goes too far
		velocity = - 0.79 * velocity
		wall = false
	elif falling:
		velocity.x = 0
		falling = false
	elif roof:
		velocity = acceleration
		roof = false

	if jump && velocity.y < 0:
		acceleration.y = - abs(acceleration.y)
	else:
		acceleration.y = abs(acceleration.y)

	collision = move_and_collide(velocity * delta)
	velocity += acceleration * delta

	if collision:
		collide()

func _input(event):
	if key_registered:
		pass

	if event.is_action("ui_left") && !event.is_action_released("ui_left"):
		move_direction = -1
		key_registered = true
	elif event.is_action("ui_right") && !event.is_action_released("ui_right"):
		move_direction = 1
		key_registered = true
	elif event.is_action_pressed("ui_accept"):
		jump_after_bounce = true
	elif event.is_action_released("ui_accept"):
		jump_after_bounce = false
		jump = false
	elif event.is_action_pressed("ui_up"):
		print(global_position)

func collide():
	global_position.x = round(global_position.x)
	
	if collision.collider.name == "BodyTop" and !key_registered and !jump_after_bounce:
		bounce = true
	elif collision.collider.name == "BodyTop" and !key_registered and jump_after_bounce:
		jump_after_bounce = false
		jump = true
	elif collision.collider.name == "BodyTop" and key_registered:
		move = true
		key_registered = false
	elif collision.collider.name == "SolidWall":
		wall = true
	elif collision.collider.name == "BodyBottom":
		if jump:
			jump = false
			jump_after_bounce = true
		roof = true

func fall(center):
	global_position.x = round(center)
	falling = true