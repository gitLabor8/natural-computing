# ##
# A Pool, or Gene pool
# ##

from gene import Gene
import numpy as np
import config as config
#TODO
# Features to implement:
# - Tournament selection: Select the best 2 out of 3 parents to crossover
# - Wheel of Fortune: Give parents a chance to be selected based on score relative to the general score
# - Cellular: Implement a 2-dimensional grid for the candidate genes to prevent local optima from spoiling the result


class Pool:
    def __init__(self):
        self.pool = list()
        self.generation = 0
        self.population_size = config.population_size
        for i in range(self.population_size):
            self.pool.append({'gene': Gene(config.amount_of_leaps), 'fitness': -1})

    def create_new_pool(self):
        print("Generating new population from mating pool.")
        self.generation = self.generation + 1
        mating_pool = self.fitness_proportionate_selection()
        self.pool = self.recombine(mating_pool)

    def get_length(self):
        return len(self.pool)

    def __str__(self):
        s = ""
        return s.join([str(gene['gene'])+", fitness="+str(gene['fitness'])+"\n"
                       for gene in self.pool])

# Selects parents from the pool at random using fitness proportionate selection
    def fitness_proportionate_selection(self):
        total = sum([gene['fitness'] for gene in self.pool])
        prob = [gene['fitness']/total for gene in self.pool]
        return np.random.choice(self.pool, size=config.mating_pool_size, replace=True, p=prob)

    def recombine(self, mating_pool):
        new_pool = list()
        for i in range(self.population_size):
            parents_idx = np.random.choice(range(0,config.mating_pool_size),2)
            parent1 = mating_pool[parents_idx[0]]['gene']
            parent2 = mating_pool[parents_idx[1]]['gene']
            offspring = parent1
            offspring.crossover(parent2)
            offspring.mutate()
            print(offspring)
            new_pool.append({'gene': offspring, 'fitness':-1})
        return new_pool
