extends CharacterBody3D

@export var speed: float = 5.0
@export var health: int = 100

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D

var target_position: Vector3

func _ready():
    # Target will be set by GameManager
    pass

func _physics_process(delta):
    if nav_agent.is_navigation_finished():
        # Reached target, damage crystal
        var crystal = get_node("/root/EnemyMap/Crystal")
        if crystal:
            crystal.take_damage(10)
        queue_free()
        return

    var next_position = nav_agent.get_next_path_position()
    var direction = (next_position - global_position).normalized()
    velocity = direction * speed
    move_and_slide()

func take_damage(amount: int):
    health -= amount
    if health <= 0:
        queue_free()

func set_target(pos: Vector3):
    target_position = pos
    nav_agent.set_target_position(target_position)