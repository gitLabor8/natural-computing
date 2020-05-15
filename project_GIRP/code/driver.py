#!/usr/bin/env python3
# Class that creates an instance of GIRP and plays games in it.

import sys, string, os

class Driver:
    def __init__(self):
        # TODO distinguish between Mac and Windows
        # Start executing GIRP.exe
        os.system("./GIRP.exe")

    # Given a sequence plays the game and returns the achieved high score
    def play_game(self, codeSequence):
        # TODO Moooooore
        return self._read_score()
        pass

    # Returns the current score displayed on the screen
    def _read_score(self):
        pass
