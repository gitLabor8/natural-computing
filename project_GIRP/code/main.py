#!/usr/bin/env python3
# ##
# Top level executing file, starts the algorithm
# ##

from driver import Driver, Fitness
from population import Population
import matplotlib.pyplot as plt
import numpy as np
import config, os, json

def visualize_fitness(id):
    with open(config.output_file) as file:
        if os.path.getsize(config.output_file) > 0:
            data = json.load(file)
    genes = [candidate_solution for candidate_solution in data if candidate_solution['id']==id]
    maxgen = genes[-1]['generation']
    plotdata = list()
    for gen in range(0, maxgen+1):
        gendata = {}
        gendata['generation'] = gen
        gendata['maxfitness'] = max([candidate_solution['fitness'] for candidate_solution in genes if candidate_solution['generation']==gen])
        gendata['averagefitness'] = sum([candidate_solution['fitness'] for candidate_solution in genes if candidate_solution['generation']==gen])/len([candidate_solution['fitness'] for candidate_solution in genes if candidate_solution['generation']==gen])
        plotdata.append(gendata)

    plt.plot(np.arange(maxgen+1), [y['maxfitness'] for y in plotdata], color='red', label='Max Fitness')
    plt.plot(np.arange(maxgen+1), [y['averagefitness'] for y in plotdata], color='blue', label='Average Fitness')
    plt.xlabel("Generation")
    plt.ylabel("Fitness")
    plt.title("Fitness over time")
    plt.legend()
    plt.show()

#


def SGA():
    population = Population()
    population.evaluate(driver)
    print("Evaluation:")
    print(str(population))
    for i in range(1, config.nr_or_generations + 1):
        population.become_successor()
        print("Evaluating population %i." % population.current_gen_number)
        population.evaluate(driver)
        print("Evaluation:")
        print(str(population))

if __name__ == '__main__':
    # driver = Driver()
    # SGA()
    visualize_fitness(id=51042402122418470103137833325575218912)
