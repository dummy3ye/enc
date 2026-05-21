import numpy as np
import pyautogui as pag
import time

print("test")

pag.moveTo(
        x= 100,
        y= 200,
        duration=5
        )
time.sleep(2)
pag.typewrite(
        message= "what",
        interval= 0
        )
