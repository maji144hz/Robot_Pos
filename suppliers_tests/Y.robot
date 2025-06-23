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
    Go To suppliers Page

 
Go To suppliers Page
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'จัดการ')]    5s
    Click Element                       xpath=//span[contains(text(), 'จัดการ')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//a[contains(text(), ' จัดการซัพพลายเออร์')]    5s
    Click Element                       xpath=//a[contains(text(), ' จัดการซัพพลายเออร์')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//h2[contains(., 'เพิ่มซัพพลายเออร์')]    5s
    Capture Page Screenshot
    



   
