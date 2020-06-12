# ##
# File with code snippets to inspect certain random functions
#  contains a lot of quick copy and paste print statements
# Note: Some of these functions might be outdated
# ##

import random
from population import Population


# Tests Population.fitness_ranked_selection()
def test_fitness_ranked_selection():
    pop = Population()
    print("Pop main:\n" + str(pop))
    for gene in pop.genes:
        gene.fitness = random.randint(0, 10)
    mating_pool = pop.fitness_ranked_selection()
    # Print statement for in the function
    # print("Ranked:\n" + "\n".join([str(gene) for gene in ranked_genes]))


