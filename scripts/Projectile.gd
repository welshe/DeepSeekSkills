extends Node3D

@export var speed: float = 20.0
var target = null
var damage: int = 10

func _physics_process(delta):
    if target == null or not is_instance_valid(target):
        queue_free()
        return

    var dir = target.global_position - global_position
    var dist = dir.length()
    if dist <= 0.5:
        if target.has_method("take_damage"):
            target.take_damage(damage)
        queue_free()
        return

    var move = dir.normalized() * speed * delta
    global_position += move
    look_at(target.global_position, Vector3.UP)
