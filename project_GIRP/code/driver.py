
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
from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains

# Indicates whether a key is currently pressed.
KEYBOARD = {'a':False, 'b':False, 'c':False, 'd':False, 'e':False, 'f':False, 'g':False, 'h':False, 'i':False, 'j':False, 'k':False, 'l':False, 'm':False, 'n':False, 'o':False, 'p':False, 'q':False, 'r':False, 's':False, 't':False, 'u':False, 'v':False, 'w':False, 'x':False, 'y':False, 'z':False, 'shift':False}
DELAY_LENGTH = 200 #200ms
def delay(t):
    time.sleep(t/1000)

class Fitness:
    def __init__(self):
        self.run = list() #After each delay in the gene (".") controller the height is recorded in this list.

    def push(self, height):
        if isinstance(height, float):
            self.run.append(height)

    def get_run(self):
        return self.run

    def get_avg_speed(self): #Denotes the avg speed in m/s, taking into account only the maximum height reached
        total_time = len(self.run)*DELAY_LENGTH
        max_height = max(self.run)

        return max_height/(total_time/1000)

    def get_fitness(self):
        return 0

class Driver:
    def __init__(self):
        self.browser = self.start_firefox()
        self.alive = False      #Indicates whether the climber is 'alive' (has not fallen in the current run).
        self.busy = False       #Indicates whether the controller is busy doing one task.
        self.progress = False   #Indicates whether the climber has made any progress in the current run.
        self.visit_GIRP()
        self.start_game(self.get_GIRP_element())
        print("Driver initialized.")

    def __del__(self):
        if self.browser:
            self.browser.quit()

    # Given a sequence plays the game and returns the fitness
    def play_game(self, codeSequence):
        # TODO
        if not self.busy:
            print("Start new run.")
            fitness = self.controller(codeSequence)
        else:
            print("Controller busy.")

    def get_GIRP_element(self):
        return self.browser.find_element_by_css_selector("div[class=post-body]")

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

    def start_firefox(self):
        fp = webdriver.FirefoxProfile()
        fp.set_preference("dom.ipc.plugins.enabled.libflashplayer.so","true")
        fp.set_preference("plugin.state.flash", 2)
        return webdriver.Firefox(fp)
        print("Firefox driver started")

    def visit_GIRP(self):
        print("Visiting GIRP URL.")
        self.browser.get('http://www.foddy.net/GIRP.html')
        delay(1000)

    def start_game(self, element):
        ac = ActionChains(self.browser)
        ac.move_to_element(element).click().perform() # Click to activate the flash player
        print("Manually Click allow.")
        delay(5000)
        print("Manually the game and start.")
        delay(2000)
        self.alive = True

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
        score_img = self.capture_score_img(self.get_GIRP_element())
        score_img = ~(np.array(score_img)[:,:,0]) #Removes rgb and inverts colors
        score_img = cv2.threshold(score_img, 20, 255, cv2.THRESH_BINARY)[1] #threshold to remove color artifacts and leave it black and white
        first_digit = self.get_digit(score_img[:,:28])
        second_digit = self.get_digit(score_img[:,32:60])
        third_digit = self.get_digit(score_img[:,64:92])

        try:
            height = float(first_digit+second_digit+third_digit)
        except:
            height =  -1.0 #error

        if height > 0.0:
            self.progress = True
        if self.progress and height == 0.0:
            self.alive = False
            self.progress = False
        if self.alive:
            return height

    def key_press(self, a):
        if a in KEYBOARD:
            keyboard.send(a, do_press=True, do_release=False)
            KEYBOARD[a] = True

    def key_release(self, a):
        if KEYBOARD[a]:
            keyboard.send(a, do_press=False, do_release=True)
            KEYBOARD[a] = False

    def controller(self, gene):
        self.busy = True
        fitness = Fitness()
        for action in gene:
            if self.alive:
                if action == "+":
                    self.key_press('shift')
                    self.key_press('shift')
                elif action == "-":
                    self.key_release('shift')
                elif action == ".":
                    delay(DELAY_LENGTH)
                    fitness.push(self.get_score())
                elif action.isupper():
                    self.key_press(action.lower())
                elif action.islower():
                    self.key_release(action)
                else:
                    print("Illegal action.")
        self.busy = False
        print(fitness.get_run())
        print(fitness.get_avg_speed())
