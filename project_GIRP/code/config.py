# Config file of the project
# All global variables are in here

# ###
# Genetic algorithm tweaks
# ###

# Mating pool size
mating_pool_size = 5

# Population size
population_size = 20

# Chance that two genes do a crossover
crossover_rate = 0.10

# Chance that a gene mutates
mutation_rate = 0.80

# ###
# Game specific tweaks
# ###

# First character that we will hold on to, based on left or righthandedness
left_handed = True
if left_handed:
    starting_characters = "bm"
else:
    starting_characters = "lr"

# What are the letters that a rock can have?
alphabet = "bmrlkdftn"

# ###
# Initialisation of values
# ###
# How long is the maximum time to flex/unflex in Time Intervals
flexing_time_lowerbound = 1
flexing_time_upperbound = 10
unflexing_time_lowerbound = 1
unflexing_time_upperbound = 5
