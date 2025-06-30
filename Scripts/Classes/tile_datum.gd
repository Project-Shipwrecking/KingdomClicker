class_name TileDatum extends Node

var tile_type : int = 0 
var biome : BiomeManager.BiomeName

var building_on_tile: Building = null
var resource_on_tile: Resources = null
var resource_amount: int = 0

var territory_owned_by : Entity = null
var selected : bool = false
