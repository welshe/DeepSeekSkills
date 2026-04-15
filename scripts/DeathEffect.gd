extends Node3D

@onready var mesh = $MeshInstance3D
@onready var timer = $Timer

func _ready():
    timer.connect("timeout", Callable(self, "_on_timer_timeout"))
    timer.start()

func _process(delta):
    mesh.scale += Vector3.ONE * delta * 3

func _on_timer_timeout():
    queue_free()
