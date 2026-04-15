extends Node3D

@export var health: int = 100

signal health_changed(new_health)

func _ready():
    emit_signal("health_changed", health)

func take_damage(amount: int):
    health -= amount
    emit_signal("health_changed", health)
    if health <= 0:
        # Game over
        print("Game Over")
        get_tree().quit()