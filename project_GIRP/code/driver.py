#!/usr/bin/env python3
# Class that creates an instance of GIRP and plays games in it.

from selenium import webdriver
from selenium.webdriver.common.keys import Keys


class Driver:
    def __init__(self):
        # Start executing GIRP.exe

        driver = webdriver.Chrome("./selenium/chromedriver.exe")
        driver.get("http://www.foddy.net/GIRP.html")
        driver.implicitly_wait(1)
        assert "GIRP" in driver.title

        driver.close()

    # Given a sequence plays the game and returns the achieved high score
    def play_game(self, codeSequence):
        # TODO Moooooore
        return self._read_score()
        pass

    # Returns the current score displayed on the screen
    def _read_score(self):
        pass
