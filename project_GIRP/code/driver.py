#!/usr/bin/env python3
# Class that creates an instance of GIRP and plays games in it.

import sys, string, os, time, keyboard
from selenium import webdriver
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains


# Indicates whether a key is currently pressed.
KEYBOARD = {'a':False, 'b':False, 'c':False, 'd':False, 'e':False, 'f':False, 'g':False, 'h':False, 'i':False, 'j':False, 'k':False, 'l':False, 'm':False, 'n':False, 'o':False, 'p':False, 'q':False, 'r':False, 's':False, 't':False, 'u':False, 'v':False, 'w':False, 'x':False, 'y':False, 'z':False, 'shift':False}
ACTIONS = {}
class Driver:
    def __init__(self):
        # TODO distinguish between Mac and Windows
        # Start executing GIRP.exe
        # os.system("./GIRP.exe")
        # self.start_chrome()
        self.start_firefox()
        self.visit_GIRP()
        self.start_game(self.get_GIRP_screen())

        print("Driver initialized.")

    def __del__(self):
        self.browser.quit()

    # Given a sequence plays the game and returns the achieved high score
    def play_game(self, codeSequence):
        # TODO Moooooore
        return self._read_score()
        pass

    # Returns the current score displayed on the screen
    def read_score(self):
        image = self.browser.get_GIRP_screen.screenshot_as_png
        im = Image.open(BytesIO(image))  # uses PIL library to open image in memory
        im.save('scr0.png')


    def start_chrome(self):

        options = webdriver.ChromeOptions()
        prefs = {
            "profile.default_content_setting_values.plugins": 1,
            "profile.content_settings.plugin_whitelist.adobe-flash-player": 1,
            "profile.content_settings.exceptions.plugins.*,*.per_resource.adobe-flash-player": 1,
            "profile.content_settings.exceptions.plugins.*,*.setting": 1
        }

        options.add_experimental_option("prefs", prefs)
        options.add_argument('--disable-features=EnableEphemeralFlashPermission')
        options.add_argument('--disable-infobars')
        options.add_argument("--ppapi-flash-version=32.0.0.101")
        options.add_argument("--ppapi-flash-path=/usr/lib/pepperflashplugin-nonfree/libpepflashplayer.so")


        # prefs = {
        #     "profile.default_content_setting_values.plugins": 1,
        #     "profile.content_settings.plugin_whitelist.adobe-flash-player": 1,
        #     "profile.content_settings.exceptions.plugins.*,*.per_resource.adobe-flash-player": 1,
        #     "PluginsAllowedForUrls": "http://www.foddy.net/"
        # }

        options.add_experimental_option("prefs",prefs)
        self.browser = webdriver.Chrome(chrome_options=options)
        print("Chrome driver started.")

    def start_firefox(self):
        fp = webdriver.FirefoxProfile()
        fp.set_preference("dom.ipc.plugins.enabled.libflashplayer.so","true")
        fp.set_preference("plugin.state.flash", 2)
        self.browser = webdriver.Firefox(fp)
        print("Firefox driver started")


    def visit_GIRP(self):
        print("Visiting GIRP URL.")
        self.browser.get('http://www.foddy.net/GIRP.html')

        time.sleep(1)


    def get_GIRP_screen(self):
        return self.browser.find_element_by_css_selector("div[class=post-body]")

    def start_game(self, element):
        ac = ActionChains(self.browser)
        ac.move_to_element(element).click().perform()
        print("Manually Click allow.")
        time.sleep(10)
        ac.move_to_element(element).click().perform()

    def key_press(self, a):
        ## TODO:
        if a in KEYBOARD:
            keyboard.send(a, do_press=True, do_release=False)
            KEYBOARD[a] = True
        elif a in actions:
            print("Nothing here.")

    def key_release(self, a):
        ## TODO:
        if KEYBOARD[a]:
            keyboard.send('a', do_press=False, do_release=True)
            KEYBOARD[a] = False

    def delay(self, t):
        time.sleep(t/1000)

    def controller(self, chromosome):
        ## TODO: Handles the execution of genetic code
        # for symbol in chromosome:
        # #TODO: BLA
        print("Nothing here.")

    def test_keyboard(self):
        print("Keyboard test.")
        self.delay(500)
        self.key_press('shift')
        self.key_press('a')
        self.delay(2000)
        self.key_release('a')
