#!/usr/bin/env python3
# Top level executing file

from driver import Driver, Fitness
import threading, queue, json
from concurrent.futures import ThreadPoolExecutor

from gene import Gene

def write_json(data):
    with open('storage/data.json','w') as f:
        json.dump(data, f, indent=4)

def store_intermedia_results(gene, fitness):
    with open('storage/data.json', ) as f:
        data = json.load(f)
        l = {'gene': gene,
            'fitness': fitness}
        data.append(l)
        write_json(data)


codeSequence = "M......F+.......-.m...D+....-.d.....f................................" #test sequence that climbs to 1.7 M
driver = Driver()
# fitness = driver.play_game(codeSequence)
# print(fitness)



queue = queue.SimpleQueue()
queue.put(codeSequence)
queue.put(codeSequence)
queue.put(codeSequence)

while not queue.empty():
    if driver.is_busy():
        print("Busy.")
        delay(1000)
    else:
        g = queue.get()
        fitness = driver.play_game(g)
        store_intermedia_results(g, fitness)





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
