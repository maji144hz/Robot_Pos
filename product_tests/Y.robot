*** Settings ***
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Login And Go To Category Page
Resource          ../login_tests/resource.robot
Library           random

*** Variables ***
${VALID_USERNAME}    1
${VALID_PASSWORD}    123
${CATEGORY_BASE}     ทดสอบหมวดหมู่

*** Test Cases ***
Add Edit Delete Category (All-in-One Robust)
    Maximize Browser Window



   

*** Keywords ***
Login And Go To Category Page
    Input Username    ${VALID_USERNAME}
    Input Password    ${VALID_PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Sleep    1s
    Capture Page Screenshot
    Go To profile Page

Go To profile Page
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'สินค้า')]    5s
    Click Element                       xpath=//span[contains(text(), 'สินค้า')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=a.p-2.text-gray-600[href='/product/']    10s
    Click Element                       css=a.p-2.text-gray-600[href='/product/']
    Capture Page Screenshot
      Go To Add Product Page

Go To Add Product Page
    # อ้างอิงวิธีใช้ contains(@class, ...) จากตัวอย่าง
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'fixed') and contains(@class, 'text-green-500') and contains(@class, 'rounded-full')]    10s
    Click Element                       xpath=//button[contains(@class, 'fixed') and contains(@class, 'text-green-500') and contains(@class, 'rounded-full')]
    Capture Page Screenshot

    



   
