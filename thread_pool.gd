extends Node

var threads = []

func _ready():
	pass


func add_job( instance, method, userdata=NULL, priority=1):
	var thread = Thread.new()
	threads.push_back({
		"parameters": userdata,
		"thread": thread
	})
	var err = thread.start(instance, method, userdata, priority)
	return err

func wait_to_finish():
	var result
	# for each thread
	for i in range(threads.size()):
		# get the result of the job
		threads[i].result = threads[i].thread.wait_to_finish()
		
	var r_threads = threads
	threads = []
	return r_threads
	
