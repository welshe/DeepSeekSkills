extends Node3D

@export var range: float = 10.0
@export var damage: int = 25
@export var fire_rate: float = 1.0

@onready var timer: Timer = $Timer
@onready var area: Area3D = $Area3D

var enemies_in_range = []

func _ready():
    timer.wait_time = 1.0 / fire_rate
    timer.connect("timeout", Callable(self, "_on_timer_timeout"))
    timer.start()
    
    area.connect("body_entered", Callable(self, "_on_body_entered"))
    area.connect("body_exited", Callable(self, "_on_body_exited"))

func _on_timer_timeout():
    if enemies_in_range.size() > 0:
        var target = enemies_in_range[0]
        target.take_damage(damage)
        # Optionally, create projectile or effect

func _on_body_entered(body):
    if body is CharacterBody3D and body.has_method("take_damage"):
        enemies_in_range.append(body)

func _on_body_exited(body):
    if body in enemies_in_range:
        enemies_in_range.erase(body)