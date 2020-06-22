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


def visualize_height(id):
    with open(config.output_file) as file:
        if os.path.getsize(config.output_file) > 0:
            data = json.load(file)
    genes = [candidate_solution for candidate_solution in data if candidate_solution['id']==id]
    maxgen = genes[-1]['generation']
    plotdata = list()
    maxheight = 0



    for gen in range(0, maxgen+1):
        gendata = {}
        maxgenheight = max([max(candidate_solution['intermediate_scores']) for candidate_solution in genes if candidate_solution['generation']==gen and candidate_solution['intermediate_scores']])
        if maxgenheight > maxheight:
            maxheight = maxgenheight
        gendata['generation'] = gen
        gendata['maxheight'] = maxheight
        plotdata.append(gendata)

    plt.plot(np.arange(maxgen+1), [y['maxheight'] for y in plotdata], color='red', label='Max reached height')
    plt.xlabel("Generation")
    plt.ylabel("Height in meters")
    plt.title("Max reached height over time")
    plt.legend()
    plt.show()


#


def SGA():
    population = Population(freeze_keys=config.freeze_keys)
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
    visualize_fitness(id=260287108202705427697009674617458730720)
    # visualize_height(id=327371651909618846958347348048145491680)

    #51042402122418470103137833325575218912 = using limited alphabet, 8 leaps

    #GIRP beaten in 3m22: https://www.youtube.com/watch?v=q1STTnctFms
    #Route: RTPSXQBDYTUOJQBLZIWOYELRZDUJVOFAWSTNZLFAGTHIRBEFDMGKCVUNLSXRPQ
    #Fixed keys, only time mutations and crossover: 290375702044397373575868582310983706336
