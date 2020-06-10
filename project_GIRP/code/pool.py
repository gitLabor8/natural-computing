from gene import Gene
import random
import numpy as np

#TODO
# Features to implement:
# - Tournament selection: Select the best 2 out of 3 parents to crossover
# - Wheel of Fortune: Give parents a chance to be selected based on score relative to the general score
# - Cellular: Implement a 2-dimensional grid for the candidate genes to prevent local optima from spoiling the result

STARTING_LETTERS = ['B', 'L', 'R', 'M'] #Boulders the climber can reach when the game starts

class Pool:
    def __init__(self, generation, population_size = 10, mating_pool=None):
        self.pool = list()
        self.generation = generation
        self.population_size = population_size
        if mating_pool is not None:
            print("Generating new population from mating pool.")
            for i in range(population_size):
                parent1 = mating_pool[0]['gene']
                parent2 = mating_pool[1]['gene']
                offspring = parent1.crossover(parent1, parent2)
                self.pool.append({'gene': offspring, 'fitness':-1})

    def generate_random_population(self, available_chars, amount_of_leaps):
        for i in range(self.population_size):
            starting_char = random.choice(STARTING_LETTERS)
            self.pool.append({'gene': Gene(available_chars, starting_char, amount_of_leaps), 'fitness':-1})

    def __str__(self):
        s=""
        return s.join([str(gene['gene'])+", fitness="+str(gene['fitness'])+"\n" for gene in self.pool])

#Selects two parents from the pool at random using fitness proportionate selection
    def fitness_proportionate_selection(self):
        total = sum([gene['fitness'] for gene in self.pool])
        prob = [gene['fitness']/total for gene in self.pool]
        result = np.random.choice(self.pool, 2, prob)
        while result[0]==result[1]:
            result = np.random.choice(self.pool, 2, prob) #Makes sure not the same parents are selected
        return result

    def getlength(self):
        return len(self.pool)
#
# def selectOne(self, population):
#     max = sum([c.fitness for c in population])
#     selection_probs = [c.fitness/max for c in population]
#     return population[npr.choice(len(population), p=selection_probs)]
