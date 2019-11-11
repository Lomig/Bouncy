extends KinematicBody2D

const GRAVITY = 5000
const LIGHT_GRAVITY = 400
const THETA = deg2rad(45)

var acceleration
var velocity

var bounce
var move
var wall
var roof
var falling
var jump_after_bounce
var jumping

var key_registered
var move_direction

# Called when the node enters the scene tree for the first time.
func _ready():
	acceleration = Vector2(0, GRAVITY)
	velocity = Vector2()

func _process(delta):
	if global_position.y > 1080:
		get_tree().reload_current_scene()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	# If jumping, decrease gravity to help aiming platforms
	if jumping:
		if velocity.y < 0 && !roof:
			acceleration.y = - LIGHT_GRAVITY
		else:
			acceleration.y = 1.5 * LIGHT_GRAVITY
	else:
		acceleration.y = GRAVITY

	if bounce:
		# velocity = - velocity -- Does not work, Bouncy keeps bouncing higher than previously
		velocity = Vector2(0, -1000)
		bounce = false
	# Ballistics physic - Here is a nice parabola
	elif move:
		var cell_width = 169 # Should be 180 / Don't know why it works better
		var direction = (cell_width / cos(THETA)) * sqrt(GRAVITY / (2 * (cell_width * tan(THETA))))

		velocity.x = move_direction * direction *cos(THETA)
		velocity.y = - direction * sin(THETA)
		
		if jumping:
			jumping = false
			jump_after_bounce = true
		move = false
		key_registered = false
	elif wall:
		# velocity = - velocity -- Same issue, Bouncy goes too far
		velocity = - 0.79 * velocity
		wall = false
	# Once leaving EmptySpace, kill Vx for Bouncy to fall in the middle of the plateform
	elif falling:
		velocity.x = 0
		falling = false
	elif roof:
		velocity = acceleration
		roof = false

	# Euler integration
	var collision = move_and_collide(velocity * delta)
	velocity += acceleration * delta

	if collision:
		collide(collision)

func _input(event):
	if event.is_action("ui_left") && !event.is_action_released("ui_left") && !key_registered:
		move_direction = -1
		key_registered = true
	elif event.is_action("ui_right") && !event.is_action_released("ui_right") && !key_registered:
		move_direction = 1
		key_registered = true
	elif event.is_action_pressed("ui_accept"):
		jump_after_bounce = true
	elif event.is_action_released("ui_accept"):
		jump_after_bounce = false
		jumping = false
	elif event.is_action_pressed("ui_up"):
		print(global_position)

func collide(collision):

	# Make sure Bouncy always bounce on the middle of the platform
	if !collision.collider.name == "SolidWall":
		global_position.x = round(collision.collider.global_position.x)

	# If we collide with the floor while idle, bounce!
	if collision.collider.name == "BodyTop" and !key_registered and !jump_after_bounce:
		$AudioBounce.play()
		bounce = true
	# If we collide with the floor preparing to jump, let's jump
	elif collision.collider.name == "BodyTop" and jump_after_bounce:
		velocity = Vector2()
		jump_after_bounce = false
		jumping = true
	# If we collide with the foor and ready to move left/right, move
	elif collision.collider.name == "BodyTop" and key_registered:
		$AudioBounce.play()
		collision.collider.get_parent().tilt(move_direction)
		move = true
	# Bounce of the wall
	elif collision.collider.name == "SolidWall":
		wall = true
	# Bounce of the roof
	elif collision.collider.name == "BodyBottom":
		roof = true

# To have a nice movement, we consider the absence of platform as a platform
# No collision for Area2D, detection done on the area itself
# This is the callback method
func fall(space):
	global_position.x = round(space.x)
	# Falling...
	if velocity.y > 0:
		falling = true
	# Jumping...
	elif key_registered:
		global_position.y = round(space.y + 14) # +14 - Hacky thing to target the middle of the next platform
		move = true
