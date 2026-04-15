extends Node3D

@export var range: float = 10.0
@export var damage: int = 25
@export var fire_rate: float = 1.0

@onready var timer: Timer = $Timer
@onready var area: Area3D = $Area3D
var enemies_in_range: Array = []
var projectile_scene = preload("res://scenes/Projectile.tscn")

func _ready():
    timer.wait_time = 1.0 / max(0.01, fire_rate)
    timer.connect("timeout", Callable(self, "_on_timer_timeout"))
    timer.start()

    area.connect("body_entered", Callable(self, "_on_body_entered"))
    area.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_timer_timeout():
    if enemies_in_range.size() > 0:
        var target = enemies_in_range[0]
        if not is_instance_valid(target):
            enemies_in_range.erase(0)
            return

        # Spawn a visual projectile that will deliver damage on impact
        var proj = projectile_scene.instantiate()
        proj.global_position = global_position + Vector3(0, 2, 0)
        proj.target = target
        proj.damage = damage
        get_parent().add_child(proj)

func _on_body_entered(body):
    if body is CharacterBody3D and body.has_method("take_damage"):
        if body not in enemies_in_range:
            enemies_in_range.append(body)

func _on_body_exited(body):
    if body in enemies_in_range:
        enemies_in_range.erase(body)