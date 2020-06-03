
#!/usr/bin/env python3
# Class that creates an instance of GIRP and plays games in it.

import sys, string, os, time, keyboard, io
from selenium import webdriver
from PIL import Image
from io import StringIO
import numpy as np
import matplotlib
import pylab as plt
import cv2
import re
import threading
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains

# Indicates whether a key is currently pressed.
KEYBOARD = {'a':False, 'b':False, 'c':False, 'd':False, 'e':False, 'f':False, 'g':False, 'h':False, 'i':False, 'j':False, 'k':False, 'l':False, 'm':False, 'n':False, 'o':False, 'p':False, 'q':False, 'r':False, 's':False, 't':False, 'u':False, 'v':False, 'w':False, 'x':False, 'y':False, 'z':False, 'shift':False}

def delay(t):
    time.sleep(t/1000)

def get_GIRP_element(browser):
    return browser.find_element_by_css_selector("div[class=post-body]")

class Fitness:
    def __init__(self, driver):
        self.score = list()
        self.alive = True
        self.browser = driver
    def __del__(self):
        pass

    def capture_score_img(self, element):
        location = element.location
        size = element.size
        img = self.browser.get_screenshot_as_png()
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
        score_right = new_left + 110 #Increase for fourth character
        score_left = new_left + 10

        img = img.crop((int(score_left), int(score_top), int(score_right), int(score_bottom)))
        img = np.asarray(img)
        return img

    def mean_squeared_error(self, imageA, imageB):
        err = np.sum((imageA.astype("float") - imageB.astype("float")) ** 2)
        err /= float(imageA.shape[0] * imageA.shape[1])
        return err

    def get_digit(self, img):
        digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "dot"]
        scores = np.asarray([self.mean_squeared_error(img, np.asarray(Image.open("digits/"+digits[i]+".png"))[:,:,0]) for i in range(0,11)])
        result = np.argwhere(scores == 0.0)
        if len(result):
            output = np.squeeze(result)
            if output < 10:
                return str(output)
            else:
                return "."
        else:
            return -1

    def get_score(self):
        score_img = self.capture_score_img(get_GIRP_element(self.browser))
        score_img = ~(np.array(score_img)[:,:,0]) #Removes rgb and inverts colors
        score_img = cv2.threshold(score_img, 20, 255, cv2.THRESH_BINARY)[1] #threshold to remove color artifacts and leave it black and white
        first_digit = self.get_digit(score_img[:,:28])
        second_digit = self.get_digit(score_img[:,32:60])
        third_digit = self.get_digit(score_img[:,64:92])
        try:
            return float(first_digit+second_digit+third_digit)
        except:
            return -1.0

    def capture_score(self):
        print("Score Thread started.")
        score = list()
        game_started = False
        while self.alive:
            height = self.get_score()
            score.append(height)
            delay(300)
            if height > 0.0:
                game_started = True
            if game_started and height == 0.0:
                self.alive = False
            print(height)
        print("Score Thread finished.")
        return score

class Controller:
    def __init__(self):
        self.browser = self.start_firefox()
        self.visit_GIRP()
        self.start_game(get_GIRP_element(self.browser))
        self.busy = False
        self.alive = False
        print("Driver initialized.")

    def __del__(self):
        if self.browser:
            self.browser.quit()

    def get_driver(self):
        return self.browser

    def play_game(self, codeSequence):
        # TODO
        print("Game controller Thread started.")
        if not self.busy:
            print("Start run.")
            self.controller(codeSequence)
        else:
            print("Busy.")
        print("Game controller Thread finished.")

    def start_firefox(self):
        fp = webdriver.FirefoxProfile()
        fp.set_preference("dom.ipc.plugins.enabled.libflashplayer.so","true")
        fp.set_preference("plugin.state.flash", 2)
        return webdriver.Firefox(fp)
        print("Firefox driver started")

    def visit_GIRP(self):
        print("Visiting GIRP URL.")
        self.browser.get('http://www.foddy.net/GIRP.html')
        time.sleep(1)

    def start_game(self, element):
        ac = ActionChains(self.browser)
        ac.move_to_element(element).click().perform() # Click to activate the flash player
        print("Manually Click allow.")
        delay(5000)
        print("Manually the game and start.")
        delay(2000)

    def key_press(self, a):
        ## TODO:
        if a in KEYBOARD:
            keyboard.send(a, do_press=True, do_release=False)
            KEYBOARD[a] = True

    def key_release(self, a):
        ## TODO:
        if KEYBOARD[a]:
            keyboard.send(a, do_press=False, do_release=True)
            KEYBOARD[a] = False

    def controller(self, gene):
        ## TODO: return fitness
        self.busy = True
        self.alive = True
        for action in gene:
            if action == "+":
                self.key_press('shift')
                self.key_press('shift')
            elif action == "-":
                self.key_release('shift')
            elif action == ".":
                delay(300)
            elif action.isupper():
                self.key_press(action.lower())
            elif action.islower():
                self.key_release(action)
            else:
                print("Illegal action.")
        self.busy = False
