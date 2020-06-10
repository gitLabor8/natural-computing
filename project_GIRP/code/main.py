#!/usr/bin/env python3
# Top level executing file

from driver import Driver, Fitness
import threading, queue, json
from concurrent.futures import ThreadPoolExecutor

from gene import Gene
from pool import Pool

def write_json(data):
    with open('storage/data.json','w') as f:
        json.dump(data, f, indent=4)

def store_intermedia_results(gene, run, fitness):
    with open('storage/data.json') as f:
        data = json.load(f)
        l = {'gene': gene,
            'data': run,
            'fitness': fitness}
        data.append(l)
        write_json(data)


# codeSequence = "M......F+.......-.m...D+....-.d.....f................................" #test sequence that climbs to 1.7 M
driver = Driver()
# fitness = driver.play_game(codeSequence)
# print(fitness)


#
# queue.put(codeSequence)
# queue.put(codeSequence)
# queue.put(codeSequence)
#
# while not queue.empty():
#     if driver.is_busy():
#         print("Busy.")
#         delay(1000)
#     else:
#         g = queue.get()
#         fitness = driver.play_game(g)
#         store_intermedia_results(g,fitness)

def evaluate_population(pool):
    for i in range(pool.getlength()):
        driver_encoding = pool.pool[i]['gene'].button_press_encoding()
        run, fitness = driver.play_game(driver_encoding)
        pool.pool[i]['fitness'] = fitness
        store_intermedia_results(str(pool.pool[i]['gene']), run, fitness)
    return

def SGA(nr_or_generations=1, available_chars="bmrlkdftn"):
    pool = Pool(generation=0, population_size=10)
    pool.generate_random_population(available_chars, 4)
    for i in range (1, nr_or_generations+1):
        print("Evaluating generation %i." % pool.generation)
        evaluate_population(pool)
        mating_pool = pool.fitness_proportionate_selection()
        pool = Pool(generation=i, population_size=10,mating_pool=mating_pool)

SGA()


# gene1 = Gene("abcdefgh", "a", 6)
# gene2 = Gene("abcdefgh", "a", 6)
# print("The parents:")
# print(str(gene1))
# print(str(gene2))
#
# # Important! Make a copy of a parent
# geneChild = gene1
# geneChild.crossover(gene2)
#
# print("The kid:")
# print(str(geneChild))
