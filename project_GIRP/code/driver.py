#!/usr/bin/env python3
# ##
# Class that creates an instance of GIRP and plays games in it.
# ##

import sys, time, keyboard, io
from selenium import webdriver
from PIL import Image
import numpy as np
import cv2
from selenium.webdriver.common.action_chains import ActionChains
import config

# Indicates whether a key is currently pressed.
KEYBOARD = {'a':True, 'b':False, 'c':False, 'd':False, 'e':False, 'f':False, 'g':False, 'h':False, 'i':False, 'j':False, 'k':False, 'l':False, 'm':False, 'n':False, 'o':False, 'p':False, 'q':False, 'r':False, 's':False, 't':False, 'u':False, 'v':False, 'w':False, 'x':False, 'y':False, 'z':False, 'shift':False}


def mean_squared_error(imageA, imageB):
    err = np.sum((imageA.astype("float") - imageB.astype("float")) ** 2)
    return err


# This class keeps track of the achieved height in the run and calculating the
#   Fitness used by the genetic algorithm.
# It does so by storing the height every 'delay' ms and calculating the average
#   climbing speed and the max reached height.

class Fitness:
    def __init__(self):
        # After each delay in the gene (".") controller the height is recorded in this list
        self.run = list()

    def push(self, height):
        if isinstance(height, float):
            self.run.append(height)

    def get_run(self):
        return self.run

    def is_valid_run(self):
        return len(self.run) > 0

    def get_max_height(self):
        return max(self.run)

# Denotes the avg speed in m/s, taking into account only the maximum height reached
    def get_avg_speed(self):
        total_time = len(self.run) * config.delay
        max_height = self.get_max_height()

        return max_height/(total_time/1000)

    def get_fitness(self):
        return self.run, self.get_avg_speed()*self.get_max_height()


# This class is used to control the browser instance of the GIRP game.
class Driver:
    def __init__(self):
        self.alive = False                          #Indicates whether the climber is 'alive' (has not fallen in the current run).
        self.busy = False                           #Indicates whether the controller is currently performing a runk.
        self.progress = False                       #Indicates whether the climber has made any progress in the current run, used to indicate whether the climber has fallen.
        self.browser = self.start_firefox()
        self.visit_GIRP()
        self.start_game(self.get_GIRP_element())
        print("Driver initialized.")

    def __del__(self):
        if self.browser:
            self.browser.quit()

    def is_busy(self):
        return self.busy
#Start Firefox-Selenium instance
    def start_firefox(self):
        fp = webdriver.FirefoxProfile()
        fp.set_preference("dom.ipc.plugins.enabled.libflashplayer.so","true")
        fp.set_preference("plugin.state.flash", 2)
        print("Firefox driver started")
        return webdriver.Firefox(fp)
#Navigate to http://foddy.net/GIRP.html
    def visit_GIRP(self):
        print("Visiting GIRP URL.")
        self.browser.get('http://www.foddy.net/GIRP.html')
        time.sleep(1)

#Initializes and focusses the game. NOTE: Manually clicking the game to start and focus is still needed.
    def start_game(self, element):
        ac = ActionChains(self.browser)
        ac.move_to_element(element).click().perform() # Click to activate the flash player
        print("Manually click allow.")
        time.sleep(5)
        print("Manually click the game-window to start the game.")
        time.sleep(5)

# Given a sequence plays the game and returns the fitness
    def play_game(self, code_sequence):
        if not self.busy:
            print("Start new run with: " + code_sequence)
            self.alive = True
            fitness = self.controller(code_sequence)
            time.sleep(2.5)
            self.busy = False
            return fitness
        else:
            print("Controller busy.")

# Localizes the game coordinates inside the browser
    def get_GIRP_element(self):
        return self.browser.find_element_by_css_selector("div[class=post-body]")

# Returns the relevant pixels to parse the displayed height
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

# Converts single digit-pixels to actual integer
    @staticmethod
    def get_digit(img):
        digits = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "dot"]
        scores = np.asarray([mean_squared_error(img, np.asarray(Image.open("digits/"+digits[i]+".png"))[:,:,0]) for i in range(0,11)])
        result = np.argwhere(scores == 0.0)
        if len(result):
            output = np.squeeze(result)
            if output < 10:
                return str(output)
            else:
                return "."
        else:
            return -1

# Converts the height-pixels to actual float denoting the height on screen
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
            height =  -0.1 #error

        if height > 0.0:
            self.progress = True
        if self.progress and height == 0.0:
            self.alive = False
            self.progress = False
        if self.alive:
            return height

# Generates a key_down event of key a
    def key_press(self, a):
        if a in KEYBOARD:
            keyboard.send(a, do_press=True, do_release=False)
            KEYBOARD[a] = True

# Generates a key_up event of key a
    def key_release(self, a):
        if KEYBOARD[a]:
            keyboard.send(a, do_press=False, do_release=True)
            KEYBOARD[a] = False

    def release_pressed_keys(self):
        pressed_keys = []
        for key in KEYBOARD:
            if KEYBOARD[key]:
                pressed_keys.append(key)
        for key in pressed_keys:
            self.key_release(key)

# Parses the gene to actual key-events
    def controller(self, gene):
        self.busy = True
        death_counter = 0
        fitness = Fitness()
        for action in gene:
            if self.alive:
                if action == "+":
                    self.key_press('shift')
                    self.key_press('shift')
                elif action == "-":
                    self.key_release('shift')
                elif action == ".":
                    time.sleep(config.delay)
                    fitness.push(self.get_score())
                elif action.isupper():
                    self.key_press(action.lower())
                    death_counter+=1
                elif action.islower():
                    self.key_release(action)
                else:
                    print("Illegal action.")
                if death_counter >= 3 and not self.progress:
                    self.alive=False
                    self.release_pressed_keys()
            else:
                print("Climber died.")
                break
        if fitness.is_valid_run():
            return fitness.get_fitness()
        else:
            return -1
