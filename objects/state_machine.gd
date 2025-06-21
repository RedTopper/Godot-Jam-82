extends Node

@export var starting_state: State

var current_state: State

func init(parent: CharacterBody2D, animations: AnimatedSprite2D, move_component, animation_tree: AnimationTree) -> void:
	for child in get_children():
		child.parent = parent
		child.animations = animations
		child.move_component = move_component
		child.animation_tree = animation_tree
	
	#initialize default state
	change_state(starting_state)

#change to the new state
func change_state(new_state: State) -> void:
	# don't change to a null state
	if not new_state:
		return
	
	if current_state:
		current_state.exit()
	
	current_state = new_state
	current_state.enter()

# pass through functions
# handling state changes as needed
func process_input(event: InputEvent) -> void:
	change_state(current_state.process_input(event))

func process_physics(delta: float) -> void:
	change_state(current_state.process_physics(delta))

func process_frame(delta: float) -> void:
	change_state(current_state.process_frame(delta))
