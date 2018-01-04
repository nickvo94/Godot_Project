extends Node2D

var rotation_ang = 50
var angle_from = 75
var angle_to = 195

func _ready():
    set_process(true)

func wrap(value, min_val, max_val):
    var f1 = value - min_val
    var f2 = max_val - min_val
    return fmod(f1, f2) + min_val

func _process(delta):
    angle_from += rotation_ang
    angle_to += rotation_ang

    # we only wrap angles if both of them are bigger than 360
    if (angle_from > 360 && angle_to > 360):
        angle_from = wrap(angle_from, 0, 360)
        angle_to = wrap(angle_to, 0, 360)
    update()

func draw_circle_arc( center, radius, angle_from, angle_to, color ):
    var nb_points = 32
    var points_arc = Vector2Array()

    for i in range(nb_points+1):
        var angle_point = angle_from + i*(angle_to-angle_from)/nb_points - 90
        var point = center + Vector2( cos(deg2rad(angle_point)), sin(deg2rad(angle_point)) ) * radius
        points_arc.push_back( point )

    for indexPoint in range(nb_points):
        draw_line(points_arc[indexPoint], points_arc[indexPoint+1], color)

func _draw():
       var center = Vector2(200,200)
       var radius = 80
       var color = Color(1.0, 0.0, 0.0)

       draw_circle_arc( center, radius, angle_from, angle_to, color )