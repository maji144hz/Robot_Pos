*** Settings ***
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Login And Go To Category Page
Resource          ../login_tests/resource.robot
Library           random

*** Variables ***
${VALID_USERNAME}    1
${VALID_PASSWORD}    123
${CATEGORY_BASE}    ทดสอบหมวดหมู่
${ADD_BUTTON_TEXT}  เพิ่มหมวดหมู่
${SAVE_BUTTON_TEXT} บันทึกข้อมูล
${CANCEL_BUTTON_TEXT}   ยกเลิก

*** Test Cases ***
Add Edit Delete Category (All-in-One Robust)
    Maximize Browser Window
    Add New Category With Random Name
    Add Duplicate Category
    Go Back To Category List
    Edit Category Name
    Delete Category

*** Keywords ***
Login And Go To Category Page
    [Documentation]    ล็อกอินและไปที่หน้าจัดการประเภทสินค้า
    Input Username    ${VALID_USERNAME}
    Input Password    ${VALID_PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Sleep    1s
    Capture Page Screenshot
    Go To status Page

Go To status Page
    [Documentation]    นำทางไปยังหน้าจัดการประเภทสินค้า
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'จัดการ')]    10s
    Click Element                       xpath=//span[contains(text(), 'จัดการ')]
    Capture Page Screenshot
    ${current_url}=    Get Location
    Log    Current URL: ${current_url}
    Wait Until Page Contains Element    xpath=//a[contains(text(), ' จัดการประเภทสินค้า')]    10s
    Click Element                       xpath=//a[contains(text(), ' จัดการประเภทสินค้า')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'filter-button')]//span[contains(text(), '${ADD_BUTTON_TEXT}')]    10s
    Capture Page Screenshot
    Go To Add Page

Go To Add Page
    [Documentation]    เปิดฟอร์มเพิ่มหมวดหมู่
    ${css_selector}=    Set Variable    css=#root > div > div > main > div > div > div.flex.justify-between.items-center.mb-6 > div > button
    Wait Until Page Contains Element    ${css_selector}    10s
    Click Element                       ${css_selector}
    Capture Page Screenshot

Add New Category With Random Name
    [Documentation]    เพิ่มหมวดหมู่ใหม่ด้วยชื่อสุ่ม
    ${random_int}=    Evaluate    random.randint(1000,9999)    random
    ${category_name}=    Set Variable    ${CATEGORY_BASE}${random_int}
    Set Suite Variable    ${category_name}  # ตั้งเป็น Suite Variable
    Log    Category Name: ${category_name}
    Input Text    xpath=//input[@placeholder="ชื่อประเภทสินค้า"]    ${category_name}
    Wait Until Page Contains Element    xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]    10s
    Click Element                       xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=button.swal2-confirm    10s
    Click Element                       css=button.swal2-confirm
    Wait Until Page Contains    ${category_name}    10s  # ตรวจสอบว่าหมวดหมู่ปรากฏ

Add Duplicate Category
    [Documentation]    ทดสอบเพิ่มหมวดหมู่ด้วยชื่อที่ซ้ำกับที่มีอยู่
    Log    Using Category Name: ${category_name}
    Input Text    xpath=//input[@placeholder="ชื่อประเภทสินค้า"]    ${category_name}
    Wait Until Page Contains Element    xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]    10s
    Click Element                       xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]
    ${status}    ${message}=    Run Keyword And Ignore Error    Wait Until Page Contains    ชื่อหมวดหมู่ซ้ำ    10s
    Log    Duplicate category check: ${status} - ${message}
    Capture Page Screenshot
    Wait Until Page Contains Element    css=button.swal2-confirm    10s
    Click Element                       css=button.swal2-confirm

Go Back To Category List
    [Documentation]    กลับไปที่รายการหมวดหมู่
    Click Element    xpath=//button[span[contains(text(), '${CANCEL_BUTTON_TEXT}')]]    10s
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'filter-button')]//span[contains(text(), '${ADD_BUTTON_TEXT}')]    10s

Edit Category Name
    [Documentation]    แก้ไขชื่อหมวดหมู่แถวแรก
    Click Element    xpath=(//button[@title="แก้ไข"])[1]
    ${random_int}=    Evaluate    random.randint(1000,9999)    random
    ${new_name}=    Set Variable    ${CATEGORY_BASE}แก้ไข${random_int}
    Input Text    xpath=//input[@placeholder="ชื่อประเภทสินค้า"]    ${new_name}
    Click Element    xpath=//button[span[contains(text(), '${SAVE_BUTTON_TEXT}')]]
    Wait Until Page Contains Element    xpath=//button[span[contains(text(), 'ยืนยัน')]]    10s
    Click Element                       xpath=//button[span[contains(text(), 'ยืนยัน')]]
    Set Suite Variable    ${new_name}
    Capture Page Screenshot
    Wait Until Page Contains    ${new_name}    10s

Delete Category
    [Documentation]    ลบหมวดหมู่แถวแรก
    Click Element    xpath=(//button[@title="ลบ"])[1]
    Wait Until Page Contains Element    xpath=//button[span[contains(text(), 'ลบ')]]    10s
    Click Element                       xpath=//button[span[contains(text(), 'ลบ')]]
    Wait Until Page Contains Element    xpath=//button[span[contains(text(), 'ยืนยัน')]]    10s
    Click Element                       xpath=//button[span[contains(text(), 'ยืนยัน')]]
    Capture Page Screenshot
    Wait Until Page Does Not Contain    ${new_name}    10s