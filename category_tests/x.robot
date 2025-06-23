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
    Add New Category With Random Name
    Add Duplicate Category
    Go Back To Category List
    Edit Category Name
    Delete Category

*** Keywords ***
Login And Go To Category Page
    Input Username    ${VALID_USERNAME}
    Input Password    ${VALID_PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Sleep    1s
    Capture Page Screenshot
    Go To status Page

Go To status Page
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'จัดการ')]    10s
    Click Element                       xpath=//span[contains(text(), 'จัดการ')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//a[contains(text(), ' จัดการประเภทสินค้า')]    10s
    Click Element                       xpath=//a[contains(text(), ' จัดการประเภทสินค้า')]
    Capture Page Screenshot
    # แก้ไข selector เป็น XPath ที่ถูกต้อง
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'filter-button')]//span[contains(text(), 'เพิ่มหมวดหมู่')]    10s
    Capture Page Screenshot
    Go To Add Page

Go To Add Page
    ${css_selector}=    Set Variable    css=#root > div > div > main > div > div > div.flex.justify-between.items-center.mb-6 > div > button
    Wait Until Page Contains Element    ${css_selector}    10s
    Click Element                       ${css_selector}
    Capture Page Screenshot

    
    


Add New Category With Random Name
    ${random_int}=    Evaluate    random.randint(1000,9999)    random
    ${category_name}=    Set Variable    ${CATEGORY_BASE}${random_int}
    Input Text    xpath=//input[@placeholder="ชื่อประเภทสินค้า"]    ${category_name}
    Wait Until Page Contains Element   xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    Click Element    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    Capture Page Screenshot
    Click Element    css=button.swal2-confirm

add
    ${css_selector}=    Set Variable    css=#root > div > div > main > div > div > div.flex.justify-between.items-center.mb-6 > div > button
    Wait Until Page Contains Element    ${css_selector}    10s
    Click Element                       ${css_selector}
    Capture Page Screenshot

Add Duplicate Category
    Input Text    xpath=//input[@placeholder="ชื่อประเภทสินค้า"]    ${category_name}
    Wait Until Page Contains Element   xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    Click Element    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    # ตรวจสอบข้อความแจ้งเตือนชื่อซ้ำ (ถ้ามี)
    Capture Page Screenshot
     Click Element    css=button.swal2-confirm

Go Back To Category List
    # สมมติว่ามีปุ่มย้อนกลับหรือปุ่มปิด modal
    Click Element    xpath=//button[span[contains(text(), 'ยกเลิก') or contains(text(), 'กลับ')]]
    Capture Page Screenshot

Edit Category Name
    # กดปุ่มแก้ไขหมวดหมู่แถวแรก
    Click Element    xpath=(//button[@title="แก้ไข"])[1]
    ${new_name}=    Set Variable    ${CATEGORY_BASE}แก้ไข${random.randint(1000,9999)}
    Input Text    xpath=//input[@placeholder="ชื่อประเภทสินค้า"]    ${new_name}
    Click Element    xpath=//button[span[contains(text(), 'บันทึกข้อมูล')]]
    Wait Until Page Contains Element    xpath=//button[span[contains(text(), 'ยืนยัน')]]    5s
    Click Element    xpath=//button[span[contains(text(), 'ยืนยัน')]]
    Set Suite Variable    ${new_name}
    Capture Page Screenshot

Delete Category
    # กดปุ่มลบหมวดหมู่แถวแรก
    Click Element    xpath=(//button[@title="ลบ"])[1]
    Wait Until Page Contains Element    xpath=//button[span[contains(text(), 'ลบ')]]    5s
    Click Element    xpath=//button[span[contains(text(), 'ลบ')]]
    Wait Until Page Contains Element    xpath=//button[span[contains(text(), 'ยืนยัน')]]    5s
    Click Element    xpath=//button[span[contains(text(), 'ยืนยัน')]]
    Capture Page Screenshot