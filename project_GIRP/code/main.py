#!/usr/bin/env python3
# Top level executing file

from driver import Driver, Fitness
from gene import Gene
from pool import Pool
import config as config
import uuid
import json

def write_json(data):
    with open('storage/data.json','w') as f:
        json.dump(data, f, indent=4)

def store_intermedia_results(gene, generation, run, fitness, id):
    with open('storage/data.json') as f:
        data = json.load(f)
        l = {'gene': gene,
            'data': run,
            'fitness': fitness,
            'id': id.int}
        data.append(l)
        write_json(data)

driver = Driver()

def evaluate_population(generation, pool, id):
    with open('storage/data.json') as f:
        history = json.load(f)
    for i in range(pool.getlength()):
        driver_encoding = pool.pool[i]['gene'].button_press_encoding()
        try:
            fitness = [obj['fitness'] for obj in history if obj['gene']==driver_encoding][0]
            print("Duplicate run found, using previous recorded fitness.")
        except:
            run, fitness = driver.play_game(driver_encoding)
            store_intermedia_results(str(pool.pool[i]['gene']),generation, run, fitness, id)
        pool.pool[i]['fitness'] = fitness

def SGA(nr_or_generations=3):
    id = uuid.uuid1()
    pool = Pool(generation=0, mating_pool=None)
    pool.generate_random_population(amount_of_leaps=8)
    evaluate_population(pool, id)
    print(str(pool))
    for i in range (1, nr_or_generations+1):
        mating_pool = pool.fitness_proportionate_selection()
        pool = Pool(generation=i,mating_pool=mating_pool)
        print("Evaluating generation %i." % pool.generation)
        evaluate_population(i, pool, id)
        print(str(pool))
SGA()

#Gene usage:
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
