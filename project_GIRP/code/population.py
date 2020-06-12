# ##
# A Generation that keeps track of a population and let's it evolve into another
# ##

from gene import Gene
import numpy as np
import config as config
import json, os
import random

# TODO Features to implement:
# - Tournament selection: Select the best 2 out of 3 parents to crossover
# - Wheel of Fortune: Give parents a chance to be selected based on score relative to the general score
# - Cellular: Implement a 2-dimensional grid for the candidate genes to prevent local optima from spoiling the result


class Population:
    def __init__(self):
        # The sample population
        self.genes = list()
        self.current_gen_number = 0
        # Instantiating the sample population
        for i in range(config.population_size):
            self.genes.append(Gene(config.amount_of_leaps))

    def become_successor(self):
        print("Changing into new population")
        self.current_gen_number = self.current_gen_number + 1
        if config.fitness_selection == 0:
            mating_pool = self.fitness_proportionate_selection()
        else:
            mating_pool = self.fitness_ranked_selection()
        self.genes = self.recombine(mating_pool)

    def __str__(self):
        return "\n".join([str(gene) for gene in self.genes])

# Selects parents from the pool at random using fitness proportionate selection
    def fitness_proportionate_selection(self):
        total = sum([gene.fitness for gene in self.genes])
        prob = [gene.fitness / total for gene in self.genes]
        return np.random.choice(self.genes, size=config.mating_pool_size, replace=True, p=prob)

    # Creates a mating pool based on ranked selection
    def fitness_ranked_selection(self):
        ranked_genes = sorted(self.genes, key=lambda x: x.fitness, reverse=True)
        # Give the genes a weight based on their rank
        #  The total length of chance_list = 40
        chance_list = [gene for gene in ranked_genes[slice(0, 3)] for i in range(5)] \
                    + [gene for gene in ranked_genes[slice(3, 12)] for i in range(2)] \
                    + [gene for gene in ranked_genes[slice(12, 21)] for i in range(1)]
        return random.choices(chance_list, k=config.mating_pool_size)

    # Uses the mating pool genes to crossover into new genes
    def recombine(self, mating_pool):
        new_pool = list()
        while len(new_pool) < config.population_size:
            random.shuffle(mating_pool)
            mom = mating_pool[0]
            dad = mating_pool[1]
            offspring = mom.crossover(dad)
            offspring.mutate()
            new_pool.append(offspring)
        return new_pool

    # Play the game and write the results to a file
    def evaluate(self, driver):
        # Load history to prevent duplicate runs from being saved
        with open(config.output_file) as file:
            if os.path.getsize(config.output_file) > 0:
                history = json.load(file)
            else:
                history = []
        # Play the game for every gene, unless we've tested it already before
        for gene in self.genes:
            driver_encoding = gene.button_press_encoding()
            # Try to prevent duplicate runs
            duplicate_runs = [gene.fitness
                              for gene in history if gene == driver_encoding]
            if duplicate_runs is []:
                print("Duplicate run found, using previous recorded fitness.")
            else:
                intermediate_scores, fitness = driver.play_game(driver_encoding)
                gene.fitness = fitness
                gene.write_out_result(self.current_gen_number, intermediate_scores)

