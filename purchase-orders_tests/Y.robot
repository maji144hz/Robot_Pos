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
    Go To purchase Page

Go To purchase Page
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'จัดการ')]    5s
    Click Element                       xpath=//span[contains(text(), 'จัดการ')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//a[contains(text(), ' จัดการใบสั่งของ')]    5s
    Click Element                       xpath=//a[contains(text(), ' จัดการใบสั่งของ')]
    Capture Page Screenshot
     # แก้ไข selector เป็น XPath ที่ถูกต้อง
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'filter-button')]//span[contains(text(), 'สร้างใบสั่งซื้อ')]    10s
    Capture Page Screenshot
    Go To Add Page

Go To Add Page
    ${css_selector}=    Set Variable    css=#root > div > div > main > div > div > div.flex.justify-between.items-center.mb-6 > div > button
    Wait Until Page Contains Element    ${css_selector}    10s
    Click Element                       ${css_selector}
    Capture Page Screenshot

    



   
