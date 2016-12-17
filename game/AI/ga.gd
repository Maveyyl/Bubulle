extends Reference


var individual_count = 12
var reproductor_individual_count = 6
var selected_individual_count = 2
var max_generation_count = 100
var max_execution_time = 1000
var exterior_stop = false

var child_per_crossover = 2
var orphan_count = 4

var mutation_rate = 0.05
var mutation_value = 10

var genetic_code_size = 10

func check_config_sanity():
	return (reproductor_individual_count / 2 ) * child_per_crossover + orphan_count + selected_individual_count == individual_count

var generation = 0
var execution_time = 0
var individuals = []
var best_individual



func run( simulation ):
	if( !check_config_sanity() ):
		return false
		
	exterior_stop = false
		
	# initialisations
	best_individual = null
	generation = 0
	execution_time = 0
	var start_execution_time = OS.get_ticks_msec()
	
	# create first generation
	individuals.resize( individual_count )
	for i in range( individual_count ):
		individuals[i] = Individual.orphan( genetic_code_size )
	
	execution_time += start_execution_time - OS.get_ticks_msec()
	
	# while execution time hasn't reached max time and generation hasn't reached max generation
	while( execution_time < max_execution_time && generation < max_generation_count && !exterior_stop ):
		# evaluate fitness of the generation
		for i in range( individual_count ):
			if( !individuals[i].fitness_score_computed ):
				compute_fitness(individuals[i], simulation)
		
		# sort the individuals by fitness score and remember the best
		var tmp_best = sort_individuals()
		if( !best_individual || tmp_best.fitness_score > best_individual.fitness_score ):
			best_individual = tmp_best
		
		# create next generation
		create_next_gen()
		
		# end loop, increment stop criteria
		execution_time = OS.get_ticks_msec() - start_execution_time 
		generation +=1

	
	var translated_gencode = []
	translated_gencode.resize( genetic_code_size )
	for i in range(0, genetic_code_size, 2):
		translated_gencode[i] = int(floor( best_individual.genetic_code[i]/(256/6)))
		translated_gencode[i+1] = int(floor( best_individual.genetic_code[i+1]/(256/4)))
	
	print("generation: ", generation, 
		" best score: ", best_individual.fitness_score, 
		" solution: ", translated_gencode[0], " ", translated_gencode[1],
		" execution time: ", execution_time)
	
	return {
		"solution": translated_gencode,
		"score": best_individual.fitness_score
	}

func create_next_gen():
	var current_index = 0
	var next_gen = []
	next_gen.resize( individual_count )
	
	for i in range(selected_individual_count):
		next_gen[i] = individuals[i]
	current_index += selected_individual_count
	
	for i in range(0, reproductor_individual_count, 2):
		for y in range(child_per_crossover):
			next_gen[current_index+i+y] = Individual.crossover( individuals[i], individuals[i+1] , mutation_rate, mutation_value)
	current_index += (reproductor_individual_count/2) * child_per_crossover

	for i in range(orphan_count):
		next_gen[current_index+i] = Individual.orphan( genetic_code_size )
		
	individuals = next_gen
		
		
func sort_individuals( ):
	var n = individuals.size()
	while( n != 0 ):
		var newn = 0
		for i in range(1, n):
			if( individuals[i-1].fitness_score < individuals[i].fitness_score ):
				swap(individuals,i-1,i)
				newn = i
		n = newn
	
	return individuals[0]

func swap(a, id1, id2):
	var tmp = a[id1]
	a[id1] = a[id2]
	a[id2] = tmp

func compute_fitness( individual, simulation ):
	var translated_gencode = []
	translated_gencode.resize( individual.genetic_code_size )
	
	var initial_score = simulation.score
	
	simulation.reset_to_base_state()
	for i in range(0, individual.genetic_code_size, 2):
		translated_gencode[i] = int(floor( individual.genetic_code[i]/(256/6)))
		translated_gencode[i+1] = int(floor( individual.genetic_code[i+1]/(256/4)))
	
	var gained_score = simulation.simulate_solution( translated_gencode )
	individual.fitness_score = gained_score







class Individual extends Reference:
	var fitness_score = 0 setget set_fitness_score
	var fitness_score_computed = false
	var genetic_code_size = 0 setget set_genetic_code_size
	var genetic_code = []

	func set_fitness_score( value ):
		fitness_score = value
		fitness_score_computed = true
		
	func set_genetic_code_size( size ):
		genetic_code_size = size
		genetic_code.resize( genetic_code_size )
	
		
	static func crossover(father, mother, mutation_rate, mutation_value):
		var individual = global.SCRIPTS.GA.Individual.new()
		individual.genetic_code_size = father.genetic_code_size
		
		for i in range(individual.genetic_code_size):
			if( randf() < 0.5 ):
				individual.genetic_code[i] = father.genetic_code[i]
			else:
				individual.genetic_code[i] = mother.genetic_code[i]
				
			if( randf() < mutation_rate ):
				var value = mutation_value * (-1 if (randf()<0.5) else -1)
				individual.genetic_code[i] += value
				if( individual.genetic_code[i] > 255 ):
					individual.genetic_code[i] = 255
				elif( individual.genetic_code[i] < 0 ):
					individual.genetic_code[i] = 0
		
		return individual
		
	static func orphan(genetic_code_size):
		var individual = global.SCRIPTS.GA.Individual.new()
		individual.genetic_code_size = genetic_code_size
		
		for i in range(genetic_code_size):
			individual.genetic_code[i] = randi()%256
			
		return individual
