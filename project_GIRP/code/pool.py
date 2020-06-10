from gene import Gene
import random
import numpy as np
import config as config

#TODO
# Features to implement:
# - Tournament selection: Select the best 2 out of 3 parents to crossover
# - Wheel of Fortune: Give parents a chance to be selected based on score relative to the general score
# - Cellular: Implement a 2-dimensional grid for the candidate genes to prevent local optima from spoiling the result

STARTING_LETTERS = ['B', 'L', 'R', 'M'] #Boulders the climber can reach when the game starts

class Pool:
    def __init__(self, generation, mating_pool=None):
        self.pool = list()
        self.generation = generation
        self.population_size = config.population_size
        if mating_pool is not None:
            print("Generating new population from mating pool.")
            self.pool = self.recombine(mating_pool)


    def getlength(self):
        return len(self.pool)

    def generate_random_population(self, amount_of_leaps):
        for i in range(self.population_size):
            self.pool.append({'gene': Gene(amount_of_leaps), 'fitness':-1})

    def __str__(self):
        s=""
        return s.join([str(gene['gene'])+", fitness="+str(gene['fitness'])+"\n" for gene in self.pool])

#Selects mating_pool_size parents from the pool at random using fitness proportionate selection
    def fitness_proportionate_selection(self):
        total = sum([gene['fitness'] for gene in self.pool])
        prob = [gene['fitness']/total for gene in self.pool]
        return np.random.choice(self.pool, size=config.mating_pool_size, replace=True, p=prob)

    def recombine(self, mating_pool):
        #TODO mutation
        new_pool = list()
        for i in range(self.population_size):
            parent1 = mating_pool[i%config.mating_pool_size]['gene']
            parent2 = mating_pool[(i+1)%config.mating_pool_size]['gene']
            offspring = parent1
            offspring.crossover(parent2)
            offspring.mutate()
            new_pool.append({'gene': offspring, 'fitness':-1})
        return new_pool
