
#!/usr/bin/env python3
# Class that creates an instance of GIRP and plays games in it.

import sys, string, os, time, keyboard, io
from selenium import webdriver
from PIL import Image
from io import StringIO
import numpy as np
import matplotlib
import pylab as plt
import pytesseract
import cv2
import re
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains

# Indicates whether a key is currently pressed.
KEYBOARD = {'a':False, 'b':False, 'c':False, 'd':False, 'e':False, 'f':False, 'g':False, 'h':False, 'i':False, 'j':False, 'k':False, 'l':False, 'm':False, 'n':False, 'o':False, 'p':False, 'q':False, 'r':False, 's':False, 't':False, 'u':False, 'v':False, 'w':False, 'x':False, 'y':False, 'z':False, 'shift':False}
ACTIONS = {} #Actions which result from decoding the genetic code.
class Driver:
    def __init__(self):
        # TODO distinguish between Mac and Windows
        # Start executing GIRP.exe
        # os.system("./GIRP.exe")
        # self.start_chrome()
        self.browser = None

        # self.start_firefox()
        # self.visit_GIRP()
        # self.start_game(self.get_GIRP_element())

        print("Driver initialized.")

    def __del__(self):
        if self.browser:
            self.browser.quit()

    # Given a sequence plays the game and returns the achieved high score
    def play_game(self, codeSequence):
        # TODO Moooooore
        self.delay(10000)
        pass

    #FROM: https://stackoverflow.com/questions/15018372/how-to-take-partial-screenshot-with-selenium-webdriver-in-python
    def capture_element(self, element, driver):
        location = element.location
        size = element.size
        img = driver.get_screenshot_as_png()
        img = Image.open(io.BytesIO(img))
        left = location['x']
        top = location['y']
        right = location['x'] + size['width'] #Actual size is 640*480
        bottom = location['y'] + size['height']
        new_left = left + ((size['width']-640)/2)
        new_right = right - ((size['width']-640)/2)
        new_bottom = location['y'] + 480
        img = img.crop((int(new_left), int(top), int(new_right), int(new_bottom)))
        img.save('screenshot.png') #This is a test
        #return img

    def capture_score_img(self, element, driver, i):
        location = element.location
        size = element.size
        img = driver.get_screenshot_as_png()
        img = Image.open(io.BytesIO(img))
        left = location['x']
        top = location['y']
        right = location['x'] + size['width'] #Actual size is 640*480
        bottom = location['y'] + size['height']
        new_left = left + ((size['width']-640)/2)
        new_right = right - ((size['width']-640)/2)
        new_bottom = location['y'] + 480

        score_bottom = new_bottom - 30
        score_top = score_bottom - 40
        score_right = new_left + 200
        score_left = new_left + 10

        img = img.crop((int(score_left), int(score_top), int(score_right), int(score_bottom)))
        img = np.asarray(img)
        # filename = "score{}".format(i)
        # plt.imsave(filename+".png", img) #This is a test
        return img

    # Returns the current score displayed on the screen


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

    def get_GIRP_element(self):
        return self.browser.find_element_by_css_selector("div[class=post-body]")

    def start_game(self, element):
        ac = ActionChains(self.browser)
        ac.move_to_element(element).click().perform() # Click to activate the flash player
        print("Manually Click allow.")
        self.delay(7000)
        # Screen-shot test
        # for i in range(0,1000):
        #     self.capture_score_img(self.get_GIRP_element(), self.browser, i)
        #     self.delay(100)

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
            keyboard.send(a, do_press=False, do_release=True)
            KEYBOARD[a] = False

    def delay(self, t):
        time.sleep(t/1000)

    def get_score(self):
        # shot = self.capture_score_img(self.get_GIRP_element(), self.browser)
        shot = Image.open("score2.png")
        img = ~(np.array(shot)[:,:,0]) #Removes rgb and inverts colors
        img = cv2.threshold(img, 20, 255, cv2.THRESH_BINARY)[1] #threshold to remove color artifacts and leave it black and white
        img = Image.fromarray(img)
        # img.save("temp.png")
        # img.show()
        score = pytesseract.image_to_string(img, config='-c tessedit_char_whitelist=0123456789m. --psm 6')
        img.show()
        # os.remove("temp.png")
        print(score)
        digits_rgx = re.compile("-?[0-9]+.?[0-9]")
        result = digits_rgx.findall(score)
        if len(result) > 0:
            score = result[0]
        else:
            score = 0
        # print(float(score))

    def controller(self, chromosome):
        ## TODO: Handles the execution of genetic code
        for symbol in chromosome:
            print("Nothing here.")
