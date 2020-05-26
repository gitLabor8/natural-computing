#!/usr/bin/env python3
# Defines the encoding and mutation of the genes

from random import randint, choice

# Explanation:
# a capital letter implies a key press
# a small letter implies a key release
# '+' implies a shift press
# '-' implies a shift release
# '.' implies a pause

# The interval chances that a pause, shift, first hand or second hand is
# used respectively
# TODO Tweak the percentages
chances = [25, 50, 75]


# One moment of gene creation
class GeneState:
    def __init__(self, available_characters):
        self.sequence = ""
        self.available_characters = available_characters
        self.shift = False
        self.key1 = ""
        self.key2 = ""

    def next_state(self):
        self.sequence = self.sequence + self.next_char()
        return self

    # Current constraints:
    #  - Max 2 capital letters active at the same time
    #  - A button cannot be pressed when it already is pressed
    #  - idem for releasing
    # TODO - Enforce at least one '.' between changes to left, right and shift
    def next_char(self):
        random = randint(0, 100)
        global chances
        # Do a pause
        if random < chances[0]:
            return "."
        # Change the shift key
        elif random < chances[1]:
            self.shift = not self.shift
            return "+" if self.shift else "-"
        # Change the first hand
        elif random < chances[2]:
            (self.key1, ret_val) = self.change_hand(self.key1)
            return ret_val
        # Change the second hand
        else:
            (self.key2, ret_val) = self.change_hand(self.key2)
            return ret_val

    # Change one hand in the encoding.
    # Returns current status to be saved and the new character
    def change_hand(self, key):
        if key == "":
            random_char = choice(self.available_characters)
            # Prevent the other hand from grabbing the same letter
            self.available_characters = self.available_characters.replace(random_char, "")
            return random_char, random_char.upper()
        else:
            # Make the key pressable again
            self.available_characters = self.available_characters + key
            return "", key.lower()

    def __str__(self):
        return "seq: \"" + self.sequence + "\", pressed keys: " + ("shift" if
               self.shift else "") + " '" + self.key1 + "', '" + self.key2 + "'"

    # Concatenate other_gene to current gene. Return 'None' if fail
    def crossover_try(self, other_gene):
        if self.shift == other_gene.shift and self.key1 == other_gene.key1 and \
                self.key2 == other_gene.key2:
            return self.sequence + other_gene.sequence
        else:
            return None


class Gene:
    # instantiates a random gene based on the unique available characters
    def __init__(self, available_characters, length):
        self.states = []
        state = GeneState(available_characters)
        for char in range(length):
            state = state.next_state()
            self.states = self.states + [state]

    # Define the length of the gene as the amount of time skips
    def __len__(self):
        return self.states[-1].sequence.count(".")

    def __str__(self):
        temp = ""
        for state in self.states:
            temp = temp + str(state) + "\n"
        return temp

    # Perform a single point crossover
    # COULD ALSO FAIL: PROBLEM
    def crossover(self, other_gene):
        crossing_points_self = list(range(len(self)))
        crossing_points_other = list(range(len(other_gene)))
        other_gene_state_number = choice(crossing_points_other)
        crossing_points_other.remove(other_gene_state_number)
        self_state_number = choice(crossing_points_self)
        crossing_points_self.remove(crossing_points_self)
        crossing = self.crossover(other_gene[other_gene_state_number])
        if crossing is not None:
            return crossing

