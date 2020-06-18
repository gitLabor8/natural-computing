#!/usr/bin/env python
# coding: utf-8

# In[ ]:

from time import time
from random import choice, sample, randint
from pandas import DataFrame

# class geneticAlgorithm:

#     #Initialized population size and mutation rate as 10
#     def __init__(self):
#         self.population = []
#         self.population_size = 10
#         self.mutation_rate = 10

#     # DNA generation based on encoding
#     def generate_dna(self):
#         choices = ["a","b","c","ab","ac","bc","abc"]
#         self.start_time = time()
#         dna = []
#         for x in range(10):
#             dna.append(choice(choices))
#         return dna
    
#     def generate_population(self):
#         self.population = []
#         for x in range(self.population_size):
#             dna = self.generate_dna()
#             self.population.append(dna)
     
#     def tournament_selection(self):
#         score = []
#         final= [] #combined list 
#         self.generate_population()
#         gene_samples = sample(self.generate_population,3)
#         for i in range(1, 4):
#             #passing the gene sample for that score value
#             score[i] = self.get_score(gene_samples[i])
#         Gene_score = {'gene_samples':gene_samples,'score':score}
#         df = DataFrame(Gene_score)
#         #combine the 2 lists
#         df_final = df.sort_values(by = ['score'], ascending=False)
#         return(df_final.head(2)) 
                        
#     def mutation(self, gene1, gene2):
#         visited = {}
#         population = []
#         for x in range(self.population_size):
#             position = randint(0, len(gene1))
#             if not visited.get(position):
#                 visited[position] = True
#                 if randint(0, 50) > 25:
#                     child = gene1[0:position] + gene2[position:]        
#                     if randint(0, 50) <= self.mutation_rate:
#                         index = randint(0, len(child) - 1)
#                         child[index] = self.generate_dna()[0]
#                     population.append(child)
#                 else:
#                     child = gene2[0:position] + gene1[position:]
#                     if randint(0, 50) < self.mutation_rate:
#                         index = randint(0, len(child) - 1)
#                         child[index] = self.generate_dna()[0]
#                     population.append(child)
#             else:
#                 population.append(self.generate_dna())
#         self.population = population

        
        
        
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
        self.genes = []
        self.current_gen_number = 0
        # Instantiating the sample population
        for i in range(config.population_size):
            self.genes.append(Gene(config.amount_of_leaps))


    def become_successor(self):
        print("Evolving into population %i." % self.current_gen_number)
        self.current_gen_number = self.current_gen_number + 1
        if config.fitness_selection == 0:
            mating_pool = self.fitness_proportionate_selection()
        else:
            mating_pool = self.tournament_selection()
        self.genes = self.recombine(mating_pool)
        print("Offspringpool:")
        print(str(self))

    def __str__(self):
        return "\n".join([str(gene) for gene in self.genes])

# Selects parents from the pool at random using fitness proportionate selection
    def fitness_proportionate_selection(self):
        total = sum([gene.fitness for gene in self.genes])
        prob = [gene.fitness / total for gene in self.genes]
        return np.random.choice(self.genes, size=config.mating_pool_size, replace=True, p=prob)
        
    
#     # Creates a mating pool based on ranked selection
#     def fitness_ranked_selection(self):
#         ranked_genes = sorted(self.genes, key=lambda x: x.fitness, reverse=True)
#         # Give the genes a weight based on their rank
#         #  The total length of chance_list = 40
#         chance_list = [gene for gene in ranked_genes[slice(0, 3)] for i in range(5)] \
#                     + [gene for gene in ranked_genes[slice(3, 12)] for i in range(2)] \
#                     + [gene for gene in ranked_genes[slice(12, 21)] for i in range(1)]
#         return random.choices(chance_list, k=config.mating_pool_size)
    tournament_count = 3
    def tournament_selection(self):
        ranked_genes = sorted(self.genes, key=lambda x: x.fitness, reverse=True)
        return ranked_genes[0:3]

    def recombine((self, mating_pool):        
#        parent_genes = random.choices(self.tournament_selection, k=2)
        new_pool = list()
#        while len(new_pool) < config.population_size:
        parent_gene = random.choice(mating_pool,k=2)
        mom = mating_pool[0]
        dad = mating_pool[1]
        offspring = dad.crossover(mom)
        offspring.mutate()
        new_pool.append(offspring)
        return new_pool
    
        # Uses the mating pool genes to crossover into new genes
#     def recombine(self, mating_pool):
#         new_pool = list()
#         while len(new_pool) < config.population_size:
#             random.shuffle(mating_pool)
#             mom = mating_pool[0]
#             dad = mating_pool[1]
#             offspring = mom.crossover(dad)
#             offspring.mutate()
#             new_pool.append(offspring)
#         return new_pool

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
            if gene.fitness == -1:
                # Try to prevent duplicate runs
                duplicate_runs = [gene['fitness'] for gene in history if gene['gene'] == str(gene)]
                if len(duplicate_runs) > 0 :
                    print("Duplicate run found, using previous recorded fitness.")
                    gene.fitness = duplicate_runs[0]
                else:
                    intermediate_scores, fitness = driver.play_game(driver_encoding)
                    gene.fitness = fitness
                    gene.write_out_result(self.current_gen_number, intermediate_scores)
            else:
                gene.write_out_result(self.current_gen_number, [])

