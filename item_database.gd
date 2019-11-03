extends Node

var item = preload("res://Item.gd")
var dropped_item = preload("res://dropped_item.tscn")
var items = {"tomato": item.new("tomato", 20, load("res://tomato.svg"))}
var player
var game

func drop_item(item, global_position, direction, qty):
	var item_instance = dropped_item.instance()
	item_instance.setup(item, global_position, direction, qty)