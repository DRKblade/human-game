extends "res://OpenPopupButton.gd"

var active_stations = Array()

func set_station(station, availability):
	if availability:
		if active_stations.size() == 0:
			visible = true
		active_stations.push_back(station)
	else:
		var index = active_stations.find(station)
		if index != -1:
			active_stations.remove(index)
			if active_stations.size() == 0:
				visible = false

func get_active_station():
	return active_stations[0]