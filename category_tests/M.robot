*** Settings ***
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Login And Go To Category Page
Resource          ../login_tests/resource.robot

*** Variables ***
${VALID_USERNAME}          1
${VALID_PASSWORD}         123
${INITIAL_CATEGORY_NAME}  หมวดหมู่ที่หนึ่ง  # ชื่อหมวดหมู่เริ่มต้นสำหรับเพิ่มและทดสอบชื่อซ้ำ
${EDITED_CATEGORY_NAME}   หมวดหมู่แก้ไขแล้ว  # ชื่อใหม่สำหรับแก้ไข
${ADD_BUTTON_TEXT}        เพิ่มหมวดหมู่
${SAVE_BUTTON_TEXT}       บันทึกข้อมูล
${CANCEL_BUTTON_TEXT}     ยกเลิก
${Delete}                 ลบ

*** Test Cases ***
Add Edit Delete Category (All-in-One Robust)
    Maximize Browser Window
    Add New Category
    Add Duplicate Category
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
    Go To Category Management Page

Go To Category Management Page
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

Add New Category
    [Documentation]    เพิ่มหมวดหมู่ใหม่ด้วยชื่อที่กำหนด
    Log    Category Name: ${INITIAL_CATEGORY_NAME}
    Input Text    xpath=//input[@placeholder="ชื่อประเภทสินค้า"]    ${INITIAL_CATEGORY_NAME}
    Wait Until Page Contains Element    xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]    10s
    Click Element                       xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=button.swal2-confirm    10s
    Click Element                       css=button.swal2-confirm
    Wait Until Page Contains    ${INITIAL_CATEGORY_NAME}    10s  # ตรวจสอบว่าหมวดหมู่ปรากฏ
    Set Suite Variable    ${category_name}    ${INITIAL_CATEGORY_NAME}  # ตั้ง Suite Variable

Add Duplicate Category
    [Documentation]    ทดสอบเพิ่มหมวดหมู่ด้วยชื่อที่ซ้ำกับที่มีอยู่
    Go To Add Page  # เปิดฟอร์มเพิ่มหมวดหมู่ใหม่
    Log    Using Category Name: ${category_name}
    Input Text    xpath=//input[@placeholder="ชื่อประเภทสินค้า"]    ${category_name}
    Wait Until Page Contains Element    xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]    10s
    Click Element                       xpath=//button[contains(text(), '${SAVE_BUTTON_TEXT}')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=button.swal2-confirm    
    Click Element                       css=button.swal2-confirm
     Wait Until Page Contains Element   xpath=//button[contains(text(), '${CANCEL_BUTTON_TEXT}')]
    Click Element    xpath=//button[contains(text(), '${CANCEL_BUTTON_TEXT}')]    
    Edit Category Name

Edit Category Name
    [Documentation]    แก้ไขชื่อหมวดหมู่ที่กำหนด
    # ค้นหาแถวที่มีชื่อหมวดหมู่ที่ต้องการแก้ไข
     Click Element    xpath=(//button[@title="แก้ไขหมวดหมู่"])[1]
    Log    Editing to Category Name: ${EDITED_CATEGORY_NAME}
    Input Text    xpath=//input[@type="text" and contains(@class, "w-full")]    ${EDITED_CATEGORY_NAME}
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

    