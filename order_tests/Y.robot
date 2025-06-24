*** Settings ***
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Login And Go To Category Page
Resource          ../login_tests/resource.robot
Library           SeleniumLibrary
Library           random

*** Variables ***
${VALID_USERNAME}    1
${VALID_PASSWORD}    123
${CATEGORY_BASE}     ทดสอบหมวดหมู่
${PRODUCT_NAME}      มาม่า รสต้มยำกุ้ง 55 กรัม  # ชื่อสินค้าที่ต้องการเลือก

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
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'ออเดอร์ขาย')]    5s
    Click Element                       xpath=//span[contains(text(), 'ออเดอร์ขาย')]
    Capture Page Screenshot
    Wait Until Page Contains Element    css=a.p-2.text-gray-600[href='/order-sell/']    10s
    Click Element                       css=a.p-2.text-gray-600[href='/order-sell/']
    Capture Page Screenshot
    Go To Add Order Page

Go To Add Order Page
    Wait Until Page Contains Element    xpath=//button[contains(@class, 'fixed') and contains(@class, 'text-green-500') and contains(@class, 'rounded-full')]    10s
    Click Element                       xpath=//button[contains(@class, 'fixed') and contains(@class, 'text-green-500') and contains(@class, 'rounded-full')]
    Capture Page Screenshot
    ClickProductItem

ClickProductItem
    [Documentation]    คลิกเลือกสินค้า มาม่า รสต้มยำกุ้ง 55 กรัม
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//div[contains(.//h2, '${PRODUCT_NAME}')]    15s
    Run Keyword If    ${status}==False    Capture Page Screenshot    product_item_error.png
    Run Keyword If    ${status}==False    Log    Product '${PRODUCT_NAME}' not found
    Run Keyword If    ${status}==True    Click Element    xpath=//div[contains(.//h2, '${PRODUCT_NAME}')]
    Capture Page Screenshot
    Sleep    2s
    Click Payment Button

Click Payment Button
    [Documentation]    คลิกปุ่มชำระเงิน
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//button[contains(text(), 'ชำระเงิน')]    10s
    Run Keyword If    ${status}==False    Capture Page Screenshot    payment_button_error.png
    Run Keyword If    ${status}==False    Log    Button 'ชำระเงิน' not found
    Run Keyword If    ${status}==True    Click Element    xpath=//button[contains(text(), 'ชำระเงิน')]
    Capture Page Screenshot
    Sleep    2s  # รอหน้าใหม่โหลด
    Click Cash Payment Button

Click Cash Payment Button
    [Documentation]    คลิกปุ่มชำระเงินด้วยเงินสด
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//button[contains(.//h3, 'เงินสด')]    10s
    Run Keyword If    ${status}==False    Capture Page Screenshot    cash_payment_error.png
    Run Keyword If    ${status}==False    Log    Button 'เงินสด' not found
    Run Keyword If    ${status}==True    Click Element    xpath=//button[contains(.//h3, 'เงินสด')]
    Capture Page Screenshot
    Sleep    2s  # รอหน้าใหม่โหลด
    Click NumberFiveButton

Click NumberFiveButton
    [Documentation]    คลิกปุ่มที่มีข้อความ 5 (สมมติกรอกจำนวนเงิน 500)
    ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//button[contains(text(), '5')]    10s
    Run Keyword If    ${status}==False    Capture Page Screenshot    number_five_error.png
    Run Keyword If    ${status}==False    Log    Button '5' not found
    Run Keyword If    ${status}==True    Click Element    xpath=//button[contains(text(), '5')]
    Run Keyword If    ${status}==True    Click Element    xpath=//button[contains(text(), '5')]
    Run Keyword If    ${status}==True    Click Element    xpath=//button[contains(text(), '5')]  # คลิก 3 ครั้งเพื่อ 500
    Capture Page Screenshot
    ${confirm_status}=    Run Keyword And Return Status    Wait Until Element Is Visible    xpath=//button[contains(text(), 'ยืนยันการชำระเงิน')]    10s
    Run Keyword If    ${confirm_status}==False    Capture Page Screenshot    confirm_payment_error.png
    Run Keyword If    ${confirm_status}==False    Log    Button 'ยืนยันการชำระเงิน' not found
    Run Keyword If    ${confirm_status}==True    Click Element    xpath=//button[contains(text(), 'ยืนยันการชำระเงิน')]
    Capture Page Screenshot
    Wait Until Element Is Visible    css=button.swal2-confirm    10s
    Click Element                       css=button.swal2-confirm
    Capture Page Screenshot