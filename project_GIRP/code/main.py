#!/usr/bin/env python3
# Top level executing file

from driver import Driver

driver = Driver()

from gene import Gene

codeSequence = "M......F+.......-....m...D+....-....d.....f................................"
driver.play_game(codeSequence)

# # Important! Make a copy of a parent
# geneChild = gene1
# geneChild.crossover(gene2)
#
# print("The kid:")
# print(str(geneChild))
