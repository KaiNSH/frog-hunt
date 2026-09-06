extends CharacterBody3D
@export var speed : float
@export var sensitivity : float
@export var friction : float = 0.9
@export var sprint_multiplier : float = 2.7
@onready var head : Node3D = $Head
@onready var stamina_bar : ProgressBar = $"Hud/Stamina Bar"
@onready var trap_prog_bar : ProgressBar = $"Hud/TrapBar"
var _mouse_motion : Vector2 = Vector2()
var stamina : float = 100
var trap_progress : float = 0
var movelock : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	print(trap_progress)
	if Input.is_action_pressed("interact") and trap_progress < 100:
		movelock = true #Ignore player input
		head.transform.basis = Basis.from_euler(Vector3(1300 * -0.001, 0, 0)) #Force player to look down
		trap_progress += 8 * delta
		trap_prog_bar.value = trap_progress
		if trap_progress >= 100:
			place_trap()
	if Input.is_action_just_released("interact"):
		movelock = false
		_mouse_motion.y = 1300
		trap_progress = 0
		trap_prog_bar.value = 0
		
	pass
	
func _physics_process(delta):
	_moving(delta)

	if stamina < 100 and not Input.is_action_pressed("sprint"):
		stamina += 0.07
	stamina_bar.value = stamina
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().quit()
	if event is InputEventMouseMotion:
		_mouse_look(event)

func _moving(delta): #Movement
	if movelock != true:
		var direction : Vector2 = Input.get_vector("left", "right", "forward", "back")
		if direction != Vector2.ZERO:
			direction = direction.normalized()
		var movement = transform.basis * Vector3(direction.x, 0, direction.y)
		movement *= speed
		
		if Input.is_action_pressed("sprint") and stamina > 0:
			movement.x *= sprint_multiplier
			movement.z *= sprint_multiplier
			stamina -= 0.25
		velocity += Vector3(movement.x, 0, movement.z)
		velocity.x *= friction
		velocity.z *= friction
		move_and_slide()

func _mouse_look(event): #Mouse Look
	if movelock != true:
		_mouse_motion += event.screen_relative * sensitivity
		_mouse_motion.y = clamp(_mouse_motion.y, -1560, 1560)
		
		transform.basis = Basis.from_euler(Vector3(0, _mouse_motion.x * -0.001, 0))
		head.transform.basis = Basis.from_euler(Vector3(_mouse_motion.y * -0.001, 0, 0))
		
func place_trap(): #dummy
	pass
