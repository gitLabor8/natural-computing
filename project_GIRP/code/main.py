#!/usr/bin/env python3
# ##
# Top level executing file, starts the algorithm
# ##

from driver import Driver, Fitness
from pool import Pool
import config
import json
from printer import store_intermediate_results

#
driver = Driver()

def evaluate_population(pool):
    # Load history to prevent duplicate runs from being saved
    with open('storage/data.json') as f:
        history = json.load(f)
    for i in range(pool.get_length()):
        driver_encoding = pool.pool[i]['gene'].button_press_encoding()
        # Try to prevent duplicate runs
        try:
            fitness = [obj['fitness']
                       for obj in history if obj['gene'] == driver_encoding][0]
            print("Duplicate run found, using previous recorded fitness.")
        except:
            run, fitness = driver.play_game(driver_encoding)
            store_intermediate_results(str(pool.pool[i]['gene']), pool.generation
                                       , run, fitness, config.id_number)
        pool.pool[i]['fitness'] = fitness

def SGA():
    pool = Pool()
    evaluate_population(pool)
    print(str(pool))
    for i in range(1, config.nr_or_generations + 1):
        pool.create_new_pool()
        print("Evaluating generation %i." % pool.generation)
        evaluate_population(pool)
        print(str(pool))

SGA()

# pool = Pool()
# print("starting random pool:")
# print(pool)
# print("1 gen:")
# pool.create_new_pool()
# print("2 gen:")
# pool.create_new_pool()
# print("3 gen:")
# pool.create_new_pool()
