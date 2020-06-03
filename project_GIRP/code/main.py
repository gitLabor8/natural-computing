#!/usr/bin/env python3
# Top level executing file

from driver import Driver

driver = Driver()

from gene import Gene

gene1 = Gene("abcdefgh", "a", 6)
gene2 = Gene("abcdefgh", "a", 6)
print("The parents:")
print(str(gene1))
print(str(gene2))

driver.play_game(gene1.button_press_encoding())

# # Important! Make a copy of a parent
# geneChild = gene1
# geneChild.crossover(gene2)
#
# print("The kid:")
# print(str(geneChild))
