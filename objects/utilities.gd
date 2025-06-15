extends Node

func get_direction_name(angle: float) -> String:
	var angle_deg = rad_to_deg(angle)
	
	if angle_deg >= 315.0 or angle_deg < 45.0:
		return "east"
	elif angle_deg >= 45.0 and angle_deg < 135.0:
		return "south"
	elif angle_deg >= 135.0 and angle_deg < 225.0:
		return "west"
	else: #angle_deg >= 225.0 and angle_deg < 315.0
		return "nordth"
