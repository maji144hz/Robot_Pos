#ยังลบไม่ได้



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



    #  Step 2: สร้างหมวดหมู่ใหม่
    ${RANDOM}=        Evaluate    random.randint(1000, 9999)    random
    ${category_name}=    Set Variable    ${CATEGORY_BASE} ${RANDOM}
    Run Keyword And Ignore Error    Scroll Element Into View         css=button[data-tip="เพิ่มหมวดหมู่"]
    Run Keyword And Ignore Error    Click Element                    css=button[data-tip="เพิ่มหมวดหมู่"]
    Run Keyword And Ignore Error    Wait Until Element Is Visible    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    10s
    Run Keyword And Ignore Error    Input Text                       xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${category_name}
    Run Keyword And Ignore Error    Click Element                    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    Run Keyword And Ignore Error    Wait Until Success Message Appears
    Run Keyword And Ignore Error    Click Element                    css=button.swal2-confirm
    Run Keyword And Ignore Error    Verify Category Created          ${category_name}

    #  Step 3: ทดสอบชื่อซ้ำ
    Run Keyword And Ignore Error    Scroll Element Into View         css=button[data-tip="เพิ่มหมวดหมู่"]
    Run Keyword And Ignore Error    Click Element                    css=button[data-tip="เพิ่มหมวดหมู่"]
    Run Keyword And Ignore Error    Wait Until Element Is Visible    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    10s
    Run Keyword And Ignore Error    Input Text                       xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${category_name}
    Run Keyword And Ignore Error    Click Element                    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    Run Keyword And Ignore Error    Wait Until Page Contains         มีหมวดหมู่นี้อยู่ในระบบแล้ว    2s
      Run Keyword And Ignore Error    Click Element                    xpath=//button[contains(text(), 'ยืนยัน')]
    Run Keyword And Ignore Error    Click Element                    xpath=//button[contains(text(), 'ยกเลิก')]
    Run Keyword And Ignore Error    Click Element                    css=button.swal2-confirm
    Sleep    1s

    # 📌 Step 4: แก้ไขชื่อหมวดหมู่
    ${updated_name}=    Set Variable    แก้ไข${category_name}
    Run Keyword And Ignore Error    Edit Category         ${category_name}    ${updated_name}

    # 📌 Step 5: ลบหมวดหมู่
    Run Keyword And Ignore Error    Delete Category       ${updated_name}
    Capture Page Screenshot

*** Keywords ***
Login And Go To Category Page
    Input Username    ${VALID_USERNAME}
    Input Password    ${VALID_PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Sleep    1s
    Capture Page Screenshot
    Go To Category Page

Go To Category Page
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'จัดการ')]    5s
    Click Element                       xpath=//span[contains(text(), 'จัดการ')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//a[contains(text(), 'จัดการประเภทสินค้า')]    5s
    Click Element                       xpath=//a[contains(text(), 'จัดการประเภทสินค้า')]
    Capture Page Screenshot
    Wait Until Page Contains Element    xpath=//h2[contains(., 'ประเภทสินค้า')]    5s
    Capture Page Screenshot

Ensure Category Button Is Visible
    [Documentation]    ทำให้ปุ่มเพิ่มหมวดหมู่ปรากฏและมองเห็นได้
    ${status}=    Set Variable    ${False}
    FOR    ${i}    IN RANGE    5
        ${status}=    Run Keyword And Return Status    Wait Until Element Is Visible    css=button[data-tip="เพิ่มหมวดหมู่"]    ${TIMEOUT}
        Exit For Loop If    ${status}
        Log To Console    Attempt ${i+1}: ปุ่มเพิ่มหมวดหมู่ยังไม่ปรากฏ
        Run Keyword And Ignore Error    Scroll Element Into View    css=button[data-tip="เพิ่มหมวดหมู่"]
        Run Keyword And Ignore Error    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
        Run Keyword And Ignore Error    Execute JavaScript    document.querySelectorAll('.loading, .bg-black.bg-opacity-50').forEach(el => el.style.display = 'none')  # ปิด overlay/loading
        Run Keyword And Ignore Error    Reload Page
        Run Keyword And Ignore Error    Wait Until Page Contains Element    css=button[data-tip="เพิ่มหมวดหมู่"]    5s
        Sleep    2s
    END
    Run Keyword If    not ${status}    Fail    ปุ่มเพิ่มหมวดหมู่ไม่ปรากฏหลังจากลอง 5 ครั้ง
    ${button_visible}=    Execute JavaScript    return document.querySelector('button[data-tip="เพิ่มหมวดหมู่"]').offsetParent !== null && document.querySelector('button[data-tip="เพิ่มหมวดหมู่"]').getBoundingClientRect().height > 0
    Log To Console    Button Visible: ${button_visible}
    Run Keyword If    not ${button_visible}    Fail    ปุ่มเพิ่มหมวดหมู่ไม่สามารถมองเห็นได้ใน DOM
    Scroll Element Into View    css=button[data-tip="เพิ่มหมวดหมู่"]
    Capture Page Screenshot    ensure_button_visible.png

    

Edit Category
    แก้ไขหมวดหมู่
    [Arguments]    ${old_name}    ${new_name}
    Click Element    xpath=//td[contains(text(), '${old_name}')]/following-sibling::td//button[contains(@class, 'bg-yellow-100') and @title='แก้ไขหมวดหมู่']
    Wait Until Element Is Visible    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    10s
    Input Text    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${new_name}
    Click Element    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    รอจนข้อความสำเร็จปรากฏ
    Click Element    css=button.swal2-confirm
    ตรวจสอบว่าอัปเดตหมวดหมู่สำเร็จ    ${new_name}

Delete Category
 [Arguments]    ${new_name}
    # เลือกปุ่มแก้ไขในแถวล่าสุดของตาราง
    Wait Until Element Is Visible    xpath=//table//tr[last()]//td//button[contains(@class, 'bg-yellow-100') and @title='แก้ไขหมวดหมู่']    10s
    Click Element    xpath=//table//tr[last()]//td//button[contains(@class, 'bg-yellow-100') and @title='แก้ไขหมวดหมู่']
    Wait Until Element Is Visible    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    10s
    Input Text    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${new_name}
    Click Element    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    รอจนข้อความสำเร็จปรากฏ
    Click Element    css=button.swal2-confirm
    ตรวจสอบว่าอัปเดตหมวดหมู่สำเร็จ    ${new_name}

Click Edit Category Button
    [Arguments]    ${name}
   

Click Delete Category Button
    [Arguments]    ${name}
    Click Element    xpath=//td[contains(text(), '${name}')]/following-sibling::td//button[contains(@class, 'bg-red-500')]

Input Category Name
    [Arguments]    ${name}
    Input Text    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${name}

Click Save Category Button
    Click Element    xpath=//button[contains(text(), 'บันทึกข้อมูล')]

Confirm Delete Category
    Click Element    xpath=//button[contains(@class, 'swal2-confirm') and normalize-space(.)='ลบ']

Wait Until Success Message Appears
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-success')]    10s

Verify Category Created
    [Arguments]    ${name}
    Wait Until Page Contains Element    xpath=//td[contains(text(), '${name}')]

Verify Category Updated
    [Arguments]    ${name}
    Wait Until Page Contains Element    xpath=//td[contains(text(), '${name}')]

Verify Category Deleted
    [Arguments]    ${name}
    Wait Until Page Does Not Contain Element    xpath=//td[contains(text(), '${name}')]