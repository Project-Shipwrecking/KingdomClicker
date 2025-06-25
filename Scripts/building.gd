class_name building
extends Node

var building = {
	
}

func add_building_data(building_id,
					building_name,
					building_texture,
					build_requirements,
					build_input,
					build_output,
					build_rate,
					building_hp):
	building[building_id] = {
		"name": building_name,
		"texture": building_texture,
		"requirements": build_requirements,
		"input": build_input,
		"output": build_output,
		"rate": build_rate,
		"hp": building_hp
	}

# Schema example: 
"""add_building_data(
	0,
	"Placeholder",
	{
		"location": {
			# idk figure this out later
		}
		"resources": {
			"Resource xxx": 999 # Number of resource xxx
		}
	},
	{
		"Resource xxx": 999 # Number of resource xxx
	},
	{
		"Resource xxx": 999 # Number of resource xxx
	},
	999 # Rate of production per minute
	999 # Building HP
)"""

func check_requirements(location_data, resources, building_id):
	var locational_requirements = building[building_id]["requirements"]["location"]
	var requirements_resources = building[building_id]["requirements"]["resources"]
	if location_data not in locational_requirements:
		return false
	for item in requirements_resources:
		if resources[item] < requirements_resources[item]:
			return false
	return true

func check_input(resources, building_id):
	var requirements = building[building_id]["input"]
	for item in requirements:
		if resources[item] < requirements[item]:
			return false
	return true
