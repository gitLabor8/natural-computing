# ##
# Config file of the project
# All global variables are in here
# ##

import uuid, json, random

# Give each run of the algorithm a unique id_number
id_number = uuid.uuid1()

# ###
# Genetic algorithm tweaks
# ###

# Total population size, how many genes do you want?
population_size = 50

# Mating pool size, how many
mating_pool_size = population_size

# Number of times that we will refresh the population
nr_or_generations = 10

# The size that we want our solutions to be
amount_of_leaps = 10

# Chance that two genes do a crossover
crossover_rate = 0.75

# Chance that one number in a gene mutates
#  So a gene with 10 leaps has 1-(1-0.20)^(1+10*2)=99% chance to mutate time
mutation_rate_timing = 0.01
# We differentiate, as mutating a letter is quite disruptive
#  So a gene with 10 leaps has 1-(1-0.05)^(1+10*2)=66% chance to mutate
mutation_rate_key = 0.01

# How to determine a mating pool
# 0 = roulette based on relative fitness
# 1 = roulette based on ranked fitness
fitness_selection = 0

# ###
# Game specific tweaks
# ###

# Delay, the step size in which we can change our behaviour in milliseconds
delay = 0.1

# First character that we will hold on to, based on left or righthandedness

starting_characters = "mr"


# What are the letters that a rock can have?
alphabet = "kdfthnjzupws"
# Or if we only want to learn the timing with a fixed sequence of letters, we specify: (this sequence is a winning sequence)
freeze_keys = None #"rtpsxqbdytuojqblziwoyelrzdujvofawstnzlfagthirbefdmgkcvunlsxrpq"



# ###
# Initialisation of values
# ###

# How long is the maximum time to flex/unflex in Time Intervals
flexing_time_lowerbound = 3
flexing_time_upperbound = 15
unflexing_time_lowerbound = 3
unflexing_time_upperbound = 15

# Keeps track of all the failed crossover attempts. Can be used for debugging
failed_crossover_attempts = 0

# ###
# Writing out the values to a file
# ###

output_file = "storage/data.json"

def write_json(data):
    with open(output_file,'w') as f:
        json.dump(data, f, indent=4)
