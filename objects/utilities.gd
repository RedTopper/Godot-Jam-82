extends Node

func get_direction_name(angle: float) -> String:
	var angle_deg = rad_to_deg(angle)
	
	if angle_deg >= 337.5 or angle_deg < 22.5: # 0
		return "east"
	elif angle_deg >= 22.5 and angle_deg < 67.5: # 45
		return "south_east"
	elif angle_deg >= 67.5 and angle_deg < 112.5: # 90
		return "south"
	elif angle_deg >= 112.5 and angle_deg < 157.5: # 135
		return "south_west"
	elif angle_deg >= 157.5 and angle_deg < 202.5: # 180
		return "west"
	elif angle_deg >= 202.5 and angle_deg < 247.5: # 225
		return "north_west"
	elif angle_deg >= 247.5 and angle_deg < 292.5: # 270
		return "north"
	else: # angle_deg >= 292.5 and angle_deg < 337.5: # 315
		return "north_east"
	
