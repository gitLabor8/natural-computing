#!/usr/bin/env python3
# Class that creates an instance of GIRP and plays games in it.

from selenium import webdriver
from selenium.webdriver.common.keys import Keys

from selenium.webdriver.common.keys import Keys
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import Select

from selenium.webdriver.common.by import By
from selenium.webdriver.common.action_chains import ActionChains
import sys


# Indicates whether a key is currently pressed.
KEYBOARD = {'a':False, 'b':False, 'c':False, 'd':False, 'e':False, 'f':False, 'g':False, 'h':False, 'i':False, 'j':False, 'k':False, 'l':False, 'm':False, 'n':False, 'o':False, 'p':False, 'q':False, 'r':False, 's':False, 't':False, 'u':False, 'v':False, 'w':False, 'x':False, 'y':False, 'z':False, 'shift':False}
ACTIONS = {} #Actions which result from decoding the genetic code.
class Driver:
    def __init__(self):
        # Start executing GIRP.exe
        self.browser = None
        self.start_chrome()
        self.browser.get("http://www.foddy.net/GIRP.html")
        self.browser.implicitly_wait(1)
        assert "GIRP" in self.browser.title

        # Letters that appear in screen
        self.availableLetters = []
        print("Driver initialized.")

    def __del__(self):
        self.browser.quit()

    # Given a sequence plays the game and returns the achieved high score
    def play_game(self, codeSequence):
        # Scrot is an abbreviation of screenshot
        self.scrot = self.capture_element(self.get_GIRP_element(), self.browser)
        # TODO Moooooore
        return self.read_score()

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
        print(right)
        print(bottom)
        img = img.crop((int(new_left), int(top), int(new_right), int(new_bottom)))
        img.save('screenshot.png') #This is a test
        #return img

    # Returns the current score displayed on the screen
    def read_score(self):
        #OpenCV template matching for recognizing the score in the bottom-left
        return None #self.scrot

    def start_chrome(self):
        options = webdriver.ChromeOptions()
        prefs = {
            "profile.default_content_setting_values.plugins": 1,
            "profile.content_settings.plugin_whitelist.adobe-flash-player": 1,
            "profile.content_settings.exceptions.plugins.*,*.per_resource.adobe-flash-player": 1,
            "profile.content_settings.exceptions.plugins.*,*.setting": 1
        }

        options.add_experimental_option("prefs", prefs)
        # options.add_argument('--disable-features=EnableEphemeralFlashPermission')
        options.add_argument('--disable-infobars')
        options.add_argument("--ppapi-flash-version=32.0.0.101")
        if sys.platform == "linux" or sys.platform == "linux2":
            options.add_argument("--ppapi-flash-path=/usr/lib/pepperflashplugin-nonfree/libpepflashplayer.so")
        elif sys.platform == "darwin": # MacOS
            options.add_argument("--ppapi-flash-path=/usr/lib/pepperflashplugin-nonfree/libpepflashplayer.so")
        elif sys.platform == "win32": # all Windows versions
            options.add_argument("--ppapi-flash-path=C:/Users/Thinkpad T460/Documents/"
                + "ru/nc/project_GIRP/code/selenium/flashplayer_32_sa_debug.exe")

        # options.add_experimental_option("prefs",prefs)
        self.browser = webdriver.Chrome("./selenium/chromedriver.exe",
                                        chrome_options=options)
        self.add_flash_site(self.browser, "http://www.foddy.net/GIRP.html")
        print("Chrome browser started.")

    def start_firefox(self):
        fp = webdriver.FirefoxProfile()
        fp.set_preference("dom.ipc.plugins.enabled.libflashplayer.so","true")
        fp.set_preference("plugin.state.flash", 2)
        self.browser = webdriver.Firefox(fp)
        print("Firefox browser started")

    def visit_GIRP(self):
        print("Visiting GIRP URL.")
        self.browser.get('http://www.foddy.net/GIRP.html')
        time.sleep(1)

    def get_GIRP_element(self):
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
        for symbol in chromosome:
            print("Nothing here.")

    def add_flash_site(driver, web_url):
        def expand_root_element(element):
            return driver.execute_script("return arguments[0].shadowRoot", element)

        driver.get("chrome://settings/content/siteDetails?site=" + web_url)
        root1 = driver.find_element(By.TAG_NAME, "settings-ui")
        shadow_root1 = expand_root_element(root1)
        root2 = shadow_root1.find_element(By.ID, "container")
        root3 = root2.find_element(By.ID, "main")
        shadow_root3 = expand_root_element(root3)
        root4 = shadow_root3.find_element(By.CLASS_NAME, "showing-subpage")
        shadow_root4 = expand_root_element(root4)
        root5 = shadow_root4.find_element(By.ID, "advancedPage")
        root6 = root5.find_element(By.TAG_NAME, "settings-privacy-page")
        shadow_root6 = expand_root_element(root6)
        root7 = shadow_root6.find_element(By.ID, "pages")
        root8 = root7.find_element(By.TAG_NAME, "settings-subpage")
        root9 = root8.find_element(By.TAG_NAME, "site-details")
        shadow_root9 = expand_root_element(root9)
        root10 = shadow_root9.find_element(By.ID, "plugins")
        shadow_root10 = expand_root_element(root10)
        root11 = shadow_root10.find_element(By.ID, "permission")
        Select(root11).select_by_value("allow")