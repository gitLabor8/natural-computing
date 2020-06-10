#!/usr/bin/env python3
# Defines the encoding of a climb in a Gene object

from random import randint, choice, shuffle

# Button press encoding:
# - a capital letter implies a key press
# - a small letter implies a key release
# - '+' implies a shift press, when to start flexing
flex = "+"
# - '-' implies a shift release, when to start unflexing
unflex = "-"
# - '.' implies a pause
pause = "."
# Example: "A....+B...a-..C+....b-." (equivalent to the compact example)

# Compact encoding:
# - Has initialisation: first letter followed by first flexing time
# - a letter means trying to grab it
# - the following int is the flexing time
# - the int after that is the unflexing time
# Example: "a4; b3-2; c4-1" (equivalent to the button press example)


class Gene:
    # Represent one climb
    # - available_characters: List that it can climb to
    # - starting_char: Character that determines if this is a left-handed or
    #                   right-handed run
    # - amount_of_leaps: Positive number
    # - In case you already have a sequence of leaps it uses that instead
    def __init__(self, available_chars, starting_char, amount_of_leaps):

        # Initialisation phase
        self.starting_char = starting_char
        self.starting_time = randint(1, 10)
        # Prevent climbing to the letter that we're holding on to
        self.available_chars = available_chars.replace(starting_char, "")

        # Climbing phase
        self.leaps = []
        prev_key = starting_char
        for leap in range(amount_of_leaps):
            block = Leap(self.available_chars, prev_key)
            # Prevent climbing to the letter that we're holding on to
            self.available_chars = self.available_chars.replace(block.key, "")
            self.leaps.append(block)
            prev_key = block.key
            # Escape if there are no characters left to pick
            if self.available_chars == "":
                break

    # Translates to a "button press encoding"
    def button_press_encoding(self):
        global pause
        return self.starting_char.upper() + str((pause * self.starting_time)) \
            + "".join([block.button_press_encoding() for block in self.leaps])

    # Translates to a "compact encoding"
    def compact_encoding(self):
        return self.starting_char + str(self.starting_time) + "; " \
            + "; ".join([block.compact_encoding() for block in self.leaps])

    # Quick debugging representation
    def __str__(self):
        return self.compact_encoding() \
            + "\navailable chars left: " + self.available_chars


    # Splits the current gene on a random point and tries to combine it with the
    # other gene
    # Results in a full new Gene
    # Cannot fail since the starting point is the same
    def crossover(self, other_gene):
        # Randomly select a point on self to cross
        cross_points_self = list(range(len(self.leaps)))
        shuffle(cross_points_self)
        for cross_point_self in cross_points_self:
            # By construction there is at most one prev_key that matches
            # Backwards gives faster matching
            for cross_point_other in range(len(other_gene.leaps)-1, -1, -1):
                if self.leaps[cross_point_self].prev_key \
                == other_gene.leaps[cross_point_other].prev_key:
                        self.leaps = self.leaps[:cross_point_self] \
                            + other_gene.leaps[cross_point_other:]
                        return
            # If there is no match we try another breaking point
        print("Warning! No crossovers found! No crossover done!")


class Leap:
    # Perform one leap to another letter
    def __init__(self, available_chars, prev_key):
        # The key that you where holding on to
        self.prev_key = prev_key
        # The new key that you're grabbing towards
        self.key = choice(available_chars)
        # TODO Tweak these random intervals
        # The time that you're flexing your muscles
        self.flex_time = randint(1, 10)
        # The time that you're releasing your muscles
        self.unflex_time = randint(1, 5)

    # Define the length of the gene as the amount of time skips
    def __len__(self):
        return self.flex_time + self.unflex_time

    # Translates to a "button press encoding"
    def button_press_encoding(self):
        global pause, flex, unflex
        return flex + self.key.upper() + (pause * self.flex_time) \
            + unflex + self.prev_key.lower() + (pause * self.unflex_time)

    # Translates to a "compact encoding"
    def compact_encoding(self):
        return self.key + str(self.flex_time) + "-" + str(self.unflex_time)

    # Quick debugging representation
    def __str__(self):
        return self.compact_encoding()
