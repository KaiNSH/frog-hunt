extends CharacterBody3D
@export var speed : float
@export var sensitivity : float
@onready var pitch = $Pitch
var _mouse_motion : Vector2 = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(delta):
	_moving(delta)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		_mouse_motion += event.screen_relative
		
		print(_mouse_motion)
		transform.basis = Basis.from_euler(Vector3(0, _mouse_motion.x * -0.001, 0))
		

	
func _moving(delta):
	var direction : Vector2 = Input.get_vector("left", "right", "forward", "back")
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	var movement = transform.basis * Vector3(direction.x, 0, direction.y)
		
	velocity += Vector3(movement.x, 0, movement.z)
	#print(direction)
	move_and_slide()

func _mouse_look(delta):
	pass
