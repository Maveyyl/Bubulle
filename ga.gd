extends Reference

func _init():
	pass
	
var individual_count_per_generation = 12
var reproductor_individual_count = 6
var selected_individual_count = 2
var max_generation_count = 80

var child_per_crossover = 2
var orphan_count = 4

var mutation_rate = 0.05

func check_sanity():
	return (reproductor_individual_count / 2 ) * child_per_crossover + orphan_count + selected_individual_count == individual_count_per_generation

