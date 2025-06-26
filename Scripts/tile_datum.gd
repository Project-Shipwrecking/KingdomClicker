## Used to hold extra information, like biome. 
## [br]
## The goal is to make adding metadata easier with this class
class_name TileDatum extends Node

var biome : BiomeManager.BiomeName
## Whatever the tile actually holds
var holding : Object
