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
Order Sell With Cash Payment
    Maximize Browser Window
    # เลือกสินค้าใดก็ได้ 1 ชิ้น
    Select Any Product In Order Sell
    # กดปุ่มชำระเงิน
    Click Element    xpath=//button[contains(text(), 'ชำระเงิน')]
    # กดชำระด้วยเงินสด
    Wait Until Element Is Visible    xpath=//button[contains(text(), 'เงินสด')]    10s
    Click Element    xpath=//button[contains(text(), 'เงินสด')]
    # ใส่ยอดเงินแบบสุ่ม (มากกว่ายอดที่ต้องชำระ)
    ${total}=    Get Order Total Amount
    ${random_cash}=    Evaluate    random.randint(${total}+1, ${total}+1000)    random
    Input Text    xpath=//input[@placeholder='รับเงิน']    ${random_cash}
    # กดยืนยันการชำระเงิน
    Click Element    xpath=//button[contains(text(), 'ยืนยันการชำระเงิน')]
    # ตรวจสอบข้อความสำเร็จ
    Wait Until Page Contains    สร้างคำสั่งซื้อสำเร็จ    10s
    Click Element    xpath=//button[contains(text(), 'ตกลง')]
    Capture Page Screenshot

*** Keywords ***
Login And Go To Order Page
  [Documentation]    ล็อกอินด้วยข้อมูลที่ถูกต้องและไปยังหน้าสินค้า
    Input Username    ${VALID_USERNAME}
    Input Password    ${VALID_PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Sleep    1s
    Capture Page Screenshot
   

Go To Order Sell Page
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'ออเดอร์ขาย')]    5s
    Click Element    xpath=//span[contains(text(), 'ออเดอร์ขาย')]
    Wait Until Page Contains Element    xpath=//a[contains(text(), 'ทั้งหมด')]    5s
    Click Element    xpath=//a[contains(text(), 'ทั้งหมด')]
    Wait Until Page Contains Element    xpath=//h2[contains(., 'ออเดอร์ขาย')]
    Capture Page Screenshot

Select Any Product In Order Sell
    # สมมติว่าสินค้าอยู่ในตารางและมีปุ่มเพิ่ม/เลือก
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'add-to-cart')]    10s
    Click Element    xpath=(//button[contains(@class, 'add-to-cart')])[1]
    Sleep    1s

Get Order Total Amount
    ${total_text}=    Get Text    xpath=//span[@id='order-total']
    ${total}=    Convert To Integer    ${total_text}
    RETURN    ${total}

Open Browser To Login Page
    Open Browser    http://localhost:5173/login    chrome
    Maximize Browser Window

Close Browser
    Close Browser 