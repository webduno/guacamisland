extends Spatial

onready var pause_screen = get_node("../pause_screen")

onready var goals = get_node("Goals")
var current_goal_index = 0;
var goal_list = [
	"goal_ring 1",
	"goal_ring 2",
	"goal_ring 3",
	"goal_ring 4",
	"goal_ring 5",
	"goal_ring 6",
	"goal_ring 7",
	"goal_ring 8",
	"goal_ring 9",
	"goal_ring 10",
	"goal_ring 11",
	"goal_ring 12",
	"goal_ring 13",
	"goal_ring 14",
	"goal_ring 15",
	"goal_ring 16",
];

onready var level_timer: Timer = get_node("Foreground/Timer")

onready var player = get_node("../Spawn/Player")

func _ready():
	player.level = self
	pause_screen.current_scene = "res://scenes/tutorial_test.tscn"
	
	goals.show()
	for x in goals.get_children():
		x.hide()
		
	var current_goal = goals.get_node(goal_list[current_goal_index])
	current_goal.show()
	current_goal.connect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")


func goal_hit():
	if	current_goal_index == 0:
		level_timer.start()
		
	var current_goal = goals.get_node(goal_list[current_goal_index])
	print(current_goal.name)
	current_goal.hide()
	current_goal.disconnect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
	
	current_goal_index += 1
	
	if current_goal_index < len(goal_list):
		current_goal = goals.get_node(goal_list[current_goal_index])
		current_goal.show()
		current_goal.connect("body_shape_entered", player, "_on_goal_ring_body_shape_entered")
	else:
		level_timer.stop()
