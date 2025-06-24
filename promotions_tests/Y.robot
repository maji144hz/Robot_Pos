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
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'fixed') and contains(@class, 'text-green-500') and contains(@class, 'rounded-full')]    10s
    Click Element                       xpath=//button[contains(@class, 'fixed') and contains(@class, 'text-green-500') and contains(@class, 'rounded-full')]
    AddPromotion

AddPromotion
    [Documentation]    กรอกและยืนยันการเพิ่มโปรโมชั่น
    # รอให้ฟอร์มโหลด
    Wait Until Element Is Visible    xpath=//h2[contains(text(), 'จัดโปรโมชั่น')]    10s
    Capture Page Screenshot

    # กรอกชื่อโปรโมชั่น
    Input Text    xpath=//input[@placeholder="ชื่อโปรโมชั่น"]    โปรโมชั่นพิเศษ 25 มิ.ย. 2025

    # กรอกวันที่เริ่มโปรโมชั่น (ใช้ค่าเริ่มต้นจากฟอร์ม หรือปรับตามต้องการ)
    Input Text    xpath=//input[@placeholder="เลือกวันที่เริ่ม"]    26 มิ.ย. 2025

    # กรอกวันที่สิ้นสุดโปรโมชั่น (ใช้ค่าเริ่มต้นจากฟอร์ม หรือปรับตามต้องการ)
    Input Text    xpath=//input[@placeholder="เลือกวันที่สิ้นสุด"]    28 มิ.ย. 2025

    # เลือกสินค้า (ตัวอย่าง: เลย์ รสโนริสาหร่าย 50 กรัม)
    Select From List By Value    xpath=//select[@class="w-full p-2 border rounded-md"]    6855aa22c16f3c50f07fc14e

    # กรอกราคา
    Input Text    xpath=//input[@type="number" and @placeholder="ราคา"]    20

    # คลิกปุ่มยืนยัน
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//button[contains(text(), 'ยืนยัน')]    10s
    Run Keyword If    ${status}==False    Capture Page Screenshot    confirm_promotion_error.png
    Run Keyword If    ${status}==False    Log    Button 'ยืนยัน' not found
    Run Keyword If    ${status}==True    Click Element    xpath=//button[contains(text(), 'ยืนยัน')]
    Capture Page Screenshot

    # รอและคลิกยืนยัน dialog (ถ้ามี SweetAlert)
    ${dialog_status}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=button.swal2-confirm    10s
    Run Keyword If    ${dialog_status}==True    Click Element    css=button.swal2-confirm
    Capture Page Screenshot

   
