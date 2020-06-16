#!/usr/bin/env python3
# ##
# Top level executing file, starts the algorithm
# ##

from driver import Driver, Fitness
from population import Population
import config

#
driver = Driver()

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

SGA()
