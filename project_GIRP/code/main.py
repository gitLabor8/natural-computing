#!/usr/bin/env python3
# Top level executing file

from driver import Controller, Fitness
import threading
from concurrent.futures import ThreadPoolExecutor


from gene import Gene

codeSequence = "M......F+.......-....m...D+....-....d.....f................................" #test sequence that climbs to 1.7 M
fitness = driver.play_game(codeSequence)
print(fitness)

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
