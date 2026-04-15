extends CharacterBody3D

@export var speed: float = 5.0
@export var health: int = 100

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
var target_position: Vector3
var target_node = null
@onready var death_scene = preload("res://scenes/DeathEffect.tscn")

func _ready():
    pass

func _physics_process(delta):
    if nav_agent.is_navigation_finished():
        # Reached target, damage crystal (via target_node reference)
        if target_node and is_instance_valid(target_node) and target_node.has_method("take_damage"):
            target_node.take_damage(10)
        queue_free()
        return

    var next_position = nav_agent.get_next_path_position()
    var dir = next_position - global_position
    if dir.length() > 0.1:
        var direction = dir.normalized()
        velocity = direction * speed
        move_and_slide()

func take_damage(amount: int):
    health -= amount
    if health <= 0:
        var eff = death_scene.instantiate()
        eff.global_position = global_position
        get_parent().add_child(eff)
        queue_free()

func set_target(pos: Vector3):
    target_position = pos
    nav_agent.set_target_position(target_position)

func set_target_node(node: Node):
    target_node = node
    if node:
        nav_agent.set_target_position(node.global_position)