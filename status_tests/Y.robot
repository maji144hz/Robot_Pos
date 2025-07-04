*** Settings ***
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Login And Go To Category Page
Resource          ../login_tests/resource.robot
Library           random

*** Variables ***
${VALID_USERNAME}    1
${VALID_PASSWORD}    123
${INITIAL_STATUS_NAME}  หมวดหมู่ที่หนึ่ง  # ชื่อหมวดหมู่เริ่มต้นสำหรับเพิ่มและทดสอบชื่อซ้ำ
${EDITED_STATUS_NAME}   หมวดหมู่แก้ไขแล้ว  # ชื่อใหม่สำหรับแก้ไข
${ADD_BUTTON_TEXT}        เพิ่มหมวดหมู่
${SAVE_BUTTON_TEXT}       บันทึกข้อมูล
${CANCEL_BUTTON_TEXT}     ยกเลิก
${Delete}                 ลบ

*** Test Cases ***
Add Edit Delete STATUS (All-in-One Robust)
    Maximize Browser Window

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
    Wait Until Page Contains Element    xpath=//a[contains(text(), ' จัดการสถานะสินค้า')]    10s
    Click Element                       xpath=//a[contains(text(), ' จัดการสถานะสินค้า')]
    Capture Page Screenshot
    # แก้ไข selector เป็น XPath ที่ถูกต้อง
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'filter-button')]//span[contains(text(), 'เพิ่มสถานะสินค้า')]    10s
    Capture Page Screenshot
    Go To Add Page

Go To Add Page
    ${css_selector}=    Set Variable    css=#root > div > div > main > div > div > div.flex.justify-between.items-center.mb-6 > div > button
    Wait Until Page Contains Element    ${css_selector}    10s
    Click Element                       ${css_selector}
    Capture Page Screenshot
    Add New status

Add New status
    [Documentation]    เพิ่มหมวดหมู่ใหม่ด้วยชื่อที่กำหนด
    Log    Status Name: ${INITIAL_STATUS_NAME}
    Input Text    xpath=//input[@placeholder="ชื่อสถานะสินค้า"]    ${INITIAL_STATUS_NAME}
    Wait Until Page Contains Element    xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]    10s
    Click Element                       xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=button.swal2-confirm    10s
    Click Element                       css=button.swal2-confirm
    Wait Until Page Contains    ${INITIAL_STATUS_NAME}    10s  # ตรวจสอบว่าหมวดหมู่ปรากฏ
    Set Suite Variable    ${INITIAL_STATUS_NAME}    ${INITIAL_STATUS_NAME}  # ตั้ง Suite Variable
    Add Duplicate Status

Add Duplicate Status
      [Documentation]    ทดสอบเพิ่มหมวดหมู่ด้วยชื่อที่ซ้ำกับที่มีอยู่
    Go To Add Page
    Log    Using Category Name: ${INITIAL_STATUS_NAME}
    Input Text    xpath=//input[@placeholder="ชื่อสถานะสินค้า"]    ${INITIAL_STATUS_NAME}
    Wait Until Page Contains Element    xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]    10s
    Click Element                       xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=button.swal2-confirm    10s
    Click Element                       css=button.swal2-confirm
    Go Back
    Capture Page Screenshot
    Edit Category Name

Edit Category Name
    [Documentation]    แก้ไขชื่อหมวดหมู่ที่กำหนด
    # ค้นหาแถวที่มีชื่อหมวดหมู่ที่ต้องการแก้ไข
     Click Element    xpath=(//button[@title="แก้ไขสถานะสินค้า"])[1]
    Log    Editing to Category Name: ${EDITED_STATUS_NAME}  
    Input Text    xpath=//input[@type="text" and contains(@class, "w-full")]    ${EDITED_STATUS_NAME}  
    Wait Until Page Contains Element    xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]    10s
    Click Element                       xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=button.swal2-confirm    
    Click Element                       css=button.swal2-confirm
    Capture Page Screenshot
   

Delete Category
    [Documentation]    ลบหมวดหมู่ที่กำหนด
    # ค้นหาแถวที่มีชื่อหมวดหมู่ที่ต้องการลบ
    Click Element    xpath=(//button[@title="ลบ"])[1]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//button[contains(text(), '${Delete}')]    10s
    Click Element                       xpath=//button[contains(text(), '${Delete}')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=button.swal2-confirm    
    Click Element                       css=button.swal2-confirm
    Capture Page Screenshot
    Wait Until Page Does Not Contain    ${category_name}    10s