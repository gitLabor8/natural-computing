#!/usr/bin/env python3
# Class that creates an instance of GIRP and plays games in it.

import sys, string, os, time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By



class Driver:
    def __init__(self):
        # TODO distinguish between Mac and Windows
        # Start executing GIRP.exe
        # os.system("./GIRP.exe")
        self.start_firefox()
        #self.start_chrome()



    # Given a sequence plays the game and returns the achieved high score
    def play_game(self, codeSequence):
        # TODO Moooooore
        return self._read_score()
        pass

    # Returns the current score displayed on the screen
    def _read_score(self):
        pass

    def start_chrome(self):
        options = webdriver.ChromeOptions()
        options.add_argument("--disable-features=EnableEphemeralFlashPermission")

        prefs = {
            "profile.default_content_setting_values.plugins": 1,
            "profile.content_settings.plugin_whitelist.adobe-flash-player": 1,
            "profile.content_settings.exceptions.plugins.*,*.per_resource.adobe-flash-player": 1,
            "PluginsAllowedForUrls": "http://www.foddy.net/"
        }

        options.add_experimental_option("prefs",prefs)
        self.browser = webdriver.Chrome(chrome_options=options)
        # self.browser = webdriver.Chrome()
        print("Chrome driver started.")

    def start_firefox(self):
        fp = webdriver.FirefoxProfile()
        fp.set_preference("plugin.state.flash", 2)
        self.browser = webdriver.Firefox(fp)
        print("Firefox driver started")



    def test_selenium(self):
        print("Visiting GIRP URL.")
        self.browser.get('http://www.foddy.net/GIRP.html')

        time.sleep(1)

        print("Clicking Flash link.")
        element = self.browser.find_element_by_partial_link_text("GET FLASH")
        # element.click()
