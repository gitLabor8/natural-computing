#!/usr/bin/env python3
# Defines the encoding and mutation of the genes

import random


class Gene:
    def __init__(self, shift: bool, key1: str, key2: str):
        self.shift = shift
        self.key1 = key1
        self.key2 = key2


class Mutation:
    # available_chars should give all visible unique characters
    # starting_gene is a random gene
    def __init__(self, available_chars: str, starting_gene: Gene):
        self.available_chars = available_chars
        self.current_gene = starting_gene

        # The higher the stiffness the less reluctant it is to try new things.
        # Value between 1 and 100. The higher the 'stiffer'
        self.stiffness = 80

    def rand_int(self):
        return random.randInt(1,101)

    # Yields a new gene based on previous gene and available characters
    def mutate(self):
        # Heighten the chance to keep shift unchanged
        if self.rand_int() > self.stiffness:
            self.current_gene.shift = not self.current_gene.shift
        if self.rand_int() > self.stiffness:
            self.current_gene.key1 = random.choice(self.available_chars)
        if self.rand_int() > self.stiffness:
            self.current_gene.key2 = random.choice(self.available_chars)
        return self.current_gene
