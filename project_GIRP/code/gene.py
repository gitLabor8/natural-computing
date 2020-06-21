# ##
#  Defines the encoding of a climb in a Gene object
# ##

from random import randint, choice, shuffle
import random
import config
import json, os

# ## Button press encoding:
# - a capital letter implies a key press
# - a small letter implies a key release
# - '+' implies a shift press, when to start flexing
flex = "+"
# - '-' implies a shift release, when to start unflexing
unflex = "-"
# - '.' implies a pause (200 ms or so, check driver for that)
pause = "."
# Example: "A....+B...a-..C+....b-." (equivalent to the compact example)

# ## Compact encoding:
# - Has initialisation: first letter followed by first unflexing time
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
    def __init__(self, amount_of_leaps, freeze_keys=None, freeze_timing=None):

        # Initialisation phase
        self.starting_char = choice(config.starting_characters).lower()
        self.starting_time = randint(config.flexing_time_lowerbound
                                     , config.flexing_time_upperbound)
        # Prevent climbing to the letter that we're holding on to
        self.available_chars = config.alphabet.lower()
        # Climbing phase
        self.leaps = []
        prev_key = self.starting_char

        if freeze_keys is not None:
            prev_key = freeze_keys[0]
            for i in range(amount_of_leaps):
                key = freeze_keys[1:][i]
                block = Leap(key, prev_key, freeze_keys=True)
                prev_key = key
                self.leaps.append(block)
        elif freeze_timing is not None:
            #TODO
            pass
        else:
            for leap in range(amount_of_leaps):
                block = Leap(self.available_chars, prev_key)
                # Prevent climbing to the letter that we're holding on to
                self.available_chars = self.available_chars.replace(block.key, "")
                self.leaps.append(block)
                prev_key = block.key
                # Escape if there are no characters left to pick
                if self.available_chars == "":
                    break
        self.fitness = -1

    # Translates to a "button press encoding"
    # Is easily readable by the driver
    def button_press_encoding(self):
        global pause
        return self.starting_char.upper() + str((pause * self.starting_time)) \
            + "".join([block.button_press_encoding() for block in self.leaps])

    # Translates to a "compact encoding"
    # Is easily readable for the user
    def compact_encoding(self):
        return self.starting_char + str(self.starting_time) + "; " \
            + "; ".join([block.compact_encoding() for block in self.leaps])

    # Quick debugging representation
    def __str__(self):
        return self.compact_encoding() + ", fitness=" + str(self.fitness)

    # Write the result of one gene to a file
    def write_out_result(self, gen_number, intermediate_scores):
        with open(config.output_file) as file:
            if os.path.getsize(config.output_file) > 0:
                data = json.load(file)
            else:
                data = []
            gene_entry = {'gene': str(self),
                          'generation': gen_number,
                          'intermediate_scores': intermediate_scores,
                          'fitness': self.fitness,
                          'id': config.id_number.int}
            data.append(gene_entry)
            config.write_json(data)

    # Splits the current gene on a random point and tries to combine it with the
    # other gene
    # Results in a full new Gene
    # Cannot fail since the starting point is the same
    # TODO skip first X seconds when score is good
    def crossover(self, other_gene):
        # Only perform crossover ever crossover_rate% of the times
        if not random.uniform(0, 1) < config.crossover_rate:
            return self
        # Randomly select a point on self to cross
        cross_points_self = list(range(len(self.leaps)))
        shuffle(cross_points_self)
        for cross_point_self in cross_points_self:
            # By construction there is at most one prev_key that matches
            # Backwards gives faster matching
            for cross_point_other in range(len(other_gene.leaps)-1, -1, -1):
                # Check if the current key that they ar holding on to is the same
                if self.leaps[cross_point_self].prev_key \
                == other_gene.leaps[cross_point_other].prev_key:
                        new_leaps = self.leaps[:cross_point_self] \
                            + other_gene.leaps[cross_point_other:]
                        # Prevent the genes from becoming too short
                        if len(new_leaps) > config.amount_of_leaps:
                            # This is how babies are made
                            child = Gene(0)
                            child.starting_char = self.starting_char
                            child.starting_time = self.starting_time
                            child.leaps = new_leaps
                            child.fitness = -1
                            return child
        # If there is no match anywhere we return self
        print("Warning! No crossovers found! No crossover done!")
        config.failed_crossover_attempts = config.failed_crossover_attempts + 1
        return self

    # Mutates the time intervals of the gene
    def mutate(self):
        old = self
        self.starting_time = mutate_time(self.starting_time)
        self.leaps = [leap.mutate() for leap in self.leaps]
        # When the gene changed the score should be reset
        if old is not self:
            self.fitness = -1
        return self


class Leap:
    # Perform one leap to another letter
    def __init__(self, available_chars, prev_key, freeze_keys=False, freeze_timing=False):
        # The key that you where holding on to
        self.prev_key = prev_key
        # The new key that you're grabbing towards
        self.key = choice(available_chars)
        # The time that you're flexing your muscles
        self.flex_time = randint(config.flexing_time_lowerbound
                                 , config.flexing_time_upperbound)
        # The time that you're releasing your muscles
        self.unflex_time = randint(config.unflexing_time_lowerbound
                                   , config.unflexing_time_upperbound)
        self.freeze_keys = freeze_keys
        self.freeze_timing = freeze_timing


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

    def mutate(self):
        if not self.freeze_timing:
            # Mutates the time intervals of one leap
            self.flex_time = mutate_time(self.flex_time)
            self.unflex_time = mutate_time(self.unflex_time)
        if not self.freeze_keys:
            # Mutate the letter that it's going to leap to
            if random.uniform(0, 1) < config.mutation_rate_key:
                self.key = choice(config.alphabet.replace(self.prev_key, ''))
        return self


# Mutates one time interval
def mutate_time(time):
    if random.uniform(0, 1) < config.mutation_rate_timing:
        # 50% chance to shorten, 50% to lengthen
        if random.choice([True, False]) and (time >= 1):
            return time - 1
        else:
            return time + 1
    else:
        return time
