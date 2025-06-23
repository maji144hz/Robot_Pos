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
    Go To promotions Page

Go To promotions Page
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'โปรโมชั่น')]    5s
    Click Element                       xpath=//span[contains(text(), 'โปรโมชั่น')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//a[contains(text(), ' จัดการสถานะสินค้า')]    5s
    Click Element                       xpath=//a[contains(text(), ' จัดการสถานะสินค้า')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//h2[contains(., 'เพิ่มสถานะสินค้า')]    5s
    Capture Page Screenshot
  

    



   
