import numpy

# Heavily inspired on
# https://towardsdatascience.com/genetic-algorithm-implementation-in-python-5ab67bb124a6
# Loads of thanks to Ahmed Gad for his tutorial

# simpleEA and memeticEA both incorporate Tournament Selection
#  but do not incorporate Elitism

def cal_pop_fitness(equation_inputs, pop):
    # Calculating the fitness value of each solution in the current population.
    # The fitness function caculates the sum of products between each input and
    # its corresponding weight.
    fitness = numpy.sum(pop*equation_inputs, axis=1)
    return fitness

def select_mating_pool(pop, fitness, num_parents):
    # Selecting the best individuals in the current generation as parents for
    #  producing the offspring of the next generation.
    parents = numpy.empty((num_parents, pop.shape[1]))
    for parent_num in range(num_parents):
        # Select the fittest
        max_fitness_idx = numpy.where(fitness == numpy.max(fitness))
        # Implementing Elitism
        max_fitness_idx = max_fitness_idx[0][0]
        parents[parent_num, :] = pop[max_fitness_idx, :]
        fitness[max_fitness_idx] = -99999999999
    return parents

def crossover(parents, offspring_size):
    offspring = numpy.empty(offspring_size)
    # The point at which crossover takes place between two parents. Usually it is
    #  at the center.
    crossover_point = numpy.uint8(offspring_size[1]/2)

    for k in range(offspring_size[0]):
        # Index of the first parent to mate.
        parent1_idx = k%parents.shape[0]
        # Index of the second parent to mate.
        parent2_idx = (k+1)%parents.shape[0]
        # The new offspring will have its first half of its genes taken from the
        #  first parent.
        offspring[k, 0:crossover_point] = parents[parent1_idx, 0:crossover_point]
        # The new offspring will have its second half of its genes taken from the
        #  second parent.
        offspring[k, crossover_point:] = parents[parent2_idx, crossover_point:]
    return offspring

def mutation(offspring_crossover):
    # Mutation changes a single gene in each offspring randomly.
    for idx in range(offspring_crossover.shape[0]):
        # The random value to be added to the gene.
        random_value = numpy.random.uniform(-1.0, 1.0, 1)
        offspring_crossover[idx, 4] = offspring_crossover[idx, 4] + random_value
    return offspring_crossover

# Read the tsp file and transform it into a genome
# Source: http://elib.zib.de/pub/mp-testdata/tsp/tsplib/tsp/a280.tsp
def readTsp(fileName : String) -> [(int, int)]:
    file = open(fileName, 'r')
    cityCoordinates = []
    for line in file:
        if "EOF":
            file.close()
            return cityList
        elif isNumber(line[0]):
            numbers = line.split
            cityCoordinates = cityCoordinates ++ [(numbers[1], numbers[2])]
    print("Escaped filereading without EOF.")
    return cityCoordinates

def validateTsp(cityCoordinates : [(int, int)]):
    pass

# Read the hamilton graph file and transform it into a genome
# Source: http://elib.zib.de/pub/mp-testdata/tsp/tsplib/hcp/alb1000.hcp
def readHamilton(fileName : String):
    pass

def simpleEA(tsp : bool):
    if tsp:
        checkStructure = readTsp()
    else:
        checkStructure = readHamilton()

def memeticEA():
    pass
