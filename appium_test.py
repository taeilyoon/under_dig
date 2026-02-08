import time
from appium import webdriver
from appium.options.common import AppiumOptions
from appium.webdriver.common.appiumby import AppiumBy

options = AppiumOptions()
options.set_capability('platformName', 'Android')
options.set_capability('automationName', 'UiAutomator2')
options.set_capability('deviceName', 'R54W3020XNK')
options.set_capability('appPackage', 'com.example.under_dig')
options.set_capability('appActivity', '.MainActivity')
options.set_capability('noReset', False)

driver = webdriver.Remote('http://localhost:4723/wd/hub', options=options)
 Maryland
print("[Appium] Session started.")

try:
    time.sleep(5) 
    
    start_button = driver.find_element(by=AppiumBy.ACCESSIBILITY_ID, value='시작하기')
    start_button.click()
    print("[Appium] Clicked '시작하기'.")
    
    time.sleep(2)
    
    size = driver.get_window_size()
    width = size['width']
    height = size['height']
    
    driver.swipe(width // 2, height // 2, width // 2, height // 2 + 200, 500)
    print("[Appium] Swiped Down.")
    time.sleep(1)
    
    driver.swipe(width // 2, height // 2, width // 2 + 200, height // 2, 500)
    print("[Appium] Swiped Right.")
    time.sleep(1)
    
    driver.swipe(width // 2, height // 2, width // 2 - 200, height // 2, 500)
    print("[Appium] Swiped Left.")
    time.sleep(1)
    
    print("[Appium] Interaction test completed successfully.")

except Exception as e:
    print(f"[Appium] Error during test: {e}")

finally:
    driver.quit()
    print("[Appium] Session ended.")
