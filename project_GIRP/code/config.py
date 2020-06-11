# ##
# Config file of the project
# All global variables are in here
# ##

import uuid

# Give each run a unique id_number
id_number = uuid.uuid1()

# ###
# Genetic algorithm tweaks
# ###

# Mating pool size, how many
mating_pool_size = 5

# Total population size, how many genes do you want?
population_size = 20

# Number of times that we will refresh the population
nr_or_generations = 3

# The size that we want our solutions to be
amount_of_leaps = 8

# Chance that two genes do a crossover
crossover_rate = 0.25#0.10

# Chance that one number in a gene mutates
#  So a gene with 10 leaps has 1-(1-0.20)^(1+10*2)=99% chance to mutate somewhere
mutation_rate = 0.20

# ###
# Game specific tweaks
# ###

# Delay, the step size in which we can change our behaviour in milliseconds
delay = 200

# First character that we will hold on to, based on left or righthandedness
left_handed = True
if left_handed:
    starting_characters = "bm"
else:
    starting_characters = "lr"

# What are the letters that a rock can have?
# alphabet = "bmrlkdftn"
alphabet = "mkrshdftnjwzpeqsxgicyv"

# ###
# Initialisation of values
# ###

# How long is the maximum time to flex/unflex in Time Intervals
flexing_time_lowerbound = 1
flexing_time_upperbound = 10
unflexing_time_lowerbound = 1
unflexing_time_upperbound = 5
