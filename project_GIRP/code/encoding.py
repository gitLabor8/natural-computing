#!/usr/bin/env python3
# Defines the encoding and mutation of the genes

from random import randint, choice

# Explanation:
# a capital letter implies a key press
# a small letter implies a key release
# '+' implies a shift press
# '-' implies a shift release
# '.' implies a pause


class Gene:
    # instantiates a random gene based on the unique available characters
    def __init__(self, available_characters, length):
        self.sequence = ""
        self.available_characters = available_characters
        self.shift = False
        self.key1 = ""
        self.key2 = ""
        # The interval chances that a pause, shift, first hand or second hand is
        # used respectively
        # TODO Tweak the percentages
        self.chances = [25, 50, 75]
        for char in range(length):
            self.sequence = self.sequence + self.next_char()

    # Current constraints:
    #  - Max 2 capital letters active at the same time
    #  - A button cannot be pressed when it already is pressed
    #  - idem for releasing
    # TODO - Enforce at least one '.' between changes to left, right and shift
    def next_char(self):
        random = randint(0, 100)
        # Do a pause
        if random < self.chances[0]:
            return "."
        # Change the shift key
        elif random < self.chances[1]:
            self.shift = not self.shift
            return "+" if self.shift else "-"
        # Change the first hand
        elif random < self.chances[2]:
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

    # Define the length of the gene as the amount of time skips
    def __len__(self):
        return self.sequence.count(".")

    # def validate()
    #     fail_reason = validate_reason
    #     if fail_reason == "":
    #         return True
    #     else:
    #         print(validate_reason)
    #         return False

    # def validate_reason()

    # Perform a single point crossover
    # def crossover(self, other_gene):
        
