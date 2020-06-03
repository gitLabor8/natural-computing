#!/usr/bin/env python3
# Top level executing file

from driver import Controller, Fitness
import threading
from concurrent.futures import ThreadPoolExecutor


from gene import Gene

controller = Controller()
fitness = Fitness(controller.get_driver())

# executor = ThreadPoolExecutor(max_workers=2)

# gene2 = Gene("abcdefgh", "a", 6)
# print("The parents:")
# print(gene1.button_press_encoding())
# print(str(gene2))

# driver.play_game(gene1.button_press_encoding())
# controller.play_game("M......F+.......-....m...D+....-....")
codeSequence = "M......F+.......-....m...D+....-...."

threading.Thread(target=controller.play_game, args=(codeSequence,)).start()
threading.Thread(target=fitness.capture_score, args=()).start()

# game = executor.submit(driver.play_game("M......F+.......-....m...D+....-...."))d
# score = executor.submit(driver.capture_score())
# ret = score.result()
# print(ret)

# # Important! Make a copy of a parent
# geneChild = gene1
# geneChild.crossover(gene2)
#
# print("The kid:")
# print(str(geneChild))
