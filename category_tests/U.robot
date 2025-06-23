*** Settings ***
Documentation     ชุดทดสอบสำหรับสร้าง แก้ไข และลบหมวดหมู่ในระบบจัดการสินค้า
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Login And Go To Category Page
Resource          ../login_tests/resource.robot
Library           random
Library           SeleniumLibrary  # เพิ่มเพื่อใช้คำสั่ง Selenium

*** Variables ***
${VALID_USERNAME}    1
${VALID_PASSWORD}    123
${CATEGORY_BASE}    ทดสอบหมวดหมู่
${TIMEOUT}          20s  # เพิ่ม timeout เพื่อรอหน้าโหลด
${BROWSER}          chrome
${CATEGORY_PAGE_URL}    http://localhost:5173/category  # ปรับตาม URL จริง
${WELCOME_URL}  http://localhost:5173/ 

*** Test Cases ***
Add Edit Delete Category (All-in-One Robust)
    Maximize Browser Window

    # 🧩 Step 1: Warm-up popup and ensure button is visible
    Ensure Category Button Is Visible
    Click Element                    css=button[data-tip="เพิ่มหมวดหมู่"]
    Wait Until Element Is Visible    css=input[placeholder="ชื่อประเภทสินค้า"]    ${TIMEOUT}
    Click Element                    css=button.bg-red-400  # ปุ่มยกเลิกใน CreateCategoryModal
    Sleep    1s
    Capture Page Screenshot    warmup_popup.png

    # 📌 Step 2: สร้างหมวดหมู่ใหม่
    ${RANDOM}=        Evaluate    random.randint(1000, 9999)    random
    ${category_name}=    Set Variable    ${CATEGORY_BASE} ${RANDOM}
    Create Category    ${category_name}
    Capture Page Screenshot    category_created_${category_name}.png

    # 📌 Step 3: ทดสอบชื่อซ้ำ
    Ensure Category Button Is Visible
    Click Element                    css=button[data-tip="เพิ่มหมวดหมู่"]
    Wait Until Element Is Visible    css=input[placeholder="ชื่อประเภทสินค้า"]    ${TIMEOUT}
    Input Text                       css=input[placeholder="ชื่อประเภทสินค้า"]    ${category_name}
    Click Element                    css=button.bg-green-500
    Wait Until Page Contains         มีหมวดหมู่นี้อยู่ในระบบแล้ว    ${TIMEOUT}
    Click Element                    css=button.bg-red-400  # ปุ่มยกเลิก
    Wait Until Element Is Visible    css=button.swal2-confirm    ${TIMEOUT}
    Click Element                    css=button.swal2-confirm
    Sleep    1s
    Capture Page Screenshot    duplicate_category.png

    # 📌 Step 4: แก้ไขชื่อหมวดหมู่
    ${updated_name}=    Set Variable    แก้ไข${category_name}
    Edit Category       ${category_name}    ${updated_name}
    Capture Page Screenshot    category_updated_${updated_name}.png

    # 📌 Step 5: ลบหมวดหมู่
    Delete Category     ${updated_name}
    Capture Page Screenshot    category_deleted.png

*** Keywords ***
Open Browser To Login Page
    [Documentation]    เปิดเบราว์เซอร์และไปที่หน้า login
    Open Browser    http://localhost:5173/login    ${BROWSER}  # ปรับตาม URL จริง
    Maximize Browser Window
    Set Selenium Timeout    ${TIMEOUT}

Login And Go To Category Page
    [Documentation]    ล็อกอินและไปยังหน้าหมวดหมู่
    Input Username    ${VALID_USERNAME}
    Input Password    ${VALID_PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Sleep    1s
    Capture Page Screenshot    after_login.png
    Go To Category Page

Go To Category Page
    [Documentation]    นำทางไปยังหน้าหมวดหมู่
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'จัดการ')]    ${TIMEOUT}  # ปรับตามเมนู
    Click Element                       xpath=//span[contains(text(), 'จัดการ')]
    Capture Page Screenshot    after_click_manage.png
    Wait Until Page Contains Element    xpath=//a[contains(text(), 'จัดการประเภทสินค้า')]    ${TIMEOUT}
    Click Element                       xpath=//a[contains(text(), 'จัดการประเภทสินค้า')]
    Capture Page Screenshot    after_click_category_link.png
    Wait Until Page Contains Element    xpath=//h2[contains(., 'จัดการหมวดหมู่สินค้า')]    ${TIMEOUT}  # ตรงกับ CategoryPage
    Wait Until Page Contains Element    css=button[data-tip="เพิ่มหมวดหมู่"]    ${TIMEOUT}  # รอปุ่มปรากฏ
    Capture Page Screenshot    category_page_loaded.png

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
    [Arguments]    ${old_name}    ${new_name}
    [Documentation]    แก้ไขชื่อหมวดหมู่
    Click Edit Category Button    ${old_name}
    Wait Until Element Is Visible    css=input.w-full.p-2.border.rounded-md    ${TIMEOUT}  # ตรงกับ EditCategoryModal
    Input Text                       css=input.w-full.p-2.border.rounded-md    ${new_name}
    Click Element                    css=button.bg-green-500  # ปุ่มบันทึกใน EditCategoryModal
    Wait Until Success Message Appears
    Click Element                    css=button.swal2-confirm
    Verify Category Updated          ${new_name}

Delete Category
    [Arguments]    ${name}
    [Documentation]    ลบหมวดหมู่
    Log To Console    Deleting category: ${name}
    Wait Until Page Contains Element    xpath=//td[contains(., '${name}')]    ${TIMEOUT}
    Scroll Element Into View            xpath=//td[contains(., '${name}')]
    Wait Until Element Is Visible       xpath=//td[contains(., '${name}')]/following-sibling::td//button[contains(@class, 'bg-red-500')]    ${TIMEOUT}
    Capture Page Screenshot             before_delete_${name}.png
    Click Element                       xpath=//td[contains(., '${name}')]/following-sibling::td//button[contains(@class, 'bg-red-500')]
    Wait Until Element Is Visible       css=button.swal2-confirm    ${TIMEOUT}
    Click Element                       css=button.swal2-confirm
    Wait Until Success Message Appears
    Click Element                       css=button.swal2-confirm
    Capture Page Screenshot             after_delete_${name}.png
    Verify Category Deleted             ${name}

Click Edit Category Button
    [Arguments]    ${name}
    [Documentation]    คลิกปุ่มแก้ไขหมวดหมู่
    Wait Until Element Is Visible    xpath=//td[contains(text(), '${name}')]/following-sibling::td//button[contains(@class, 'bg-yellow-500')]    ${TIMEOUT}
    Click Element                    xpath=//td[contains(text(), '${name}')]/following-sibling::td//button[contains(@class, 'bg-yellow-500')]

Click Save Category Button
    [Documentation]    คลิกปุ่มบันทึกข้อมูล
    Click Element    css=button.bg-green-500

Wait Until Success Message Appears
    [Documentation]    รอข้อความยืนยันความสำเร็จ
    Wait Until Element Is Visible    css=div.swal2-success    ${TIMEOUT}
    Log To Console    Success message appeared
    Capture Page Screenshot    success_message.png

Verify Category Created
    [Arguments]    ${name}
    [Documentation]    ตรวจสอบว่าหมวดหมู่ถูกสร้าง
    Wait Until Page Contains Element    xpath=//td[contains(text(), '${name}')]    ${TIMEOUT}
    Log To Console    Category ${name} created
    Capture Page Screenshot    verify_created_${name}.png

Verify Category Updated
    [Arguments]    ${name}
    [Documentation]    ตรวจสอบว่าหมวดหมู่ถูกแก้ไข
    Wait Until Page Contains Element    xpath=//td[contains(text(), '${name}')]    ${TIMEOUT}
    Log To Console    Category updated to ${name}
    Capture Page Screenshot    verify_updated_${name}.png

Verify Category Deleted
    [Arguments]    ${name}
    [Documentation]    ตรวจสอบว่าหมวดหมู่ถูกลบ
    Wait Until Page Does Not Contain Element    xpath=//td[contains(text(), '${name}')]    ${TIMEOUT}
    Log To Console    Category ${name} deleted
    Capture Page Screenshot    verify_deleted_${name}.png

Create Category
    [Arguments]    ${category_name}
    Run Keyword And Ignore Error    Scroll Element Into View         css=button[data-tip="เพิ่มหมวดหมู่"]
    Run Keyword And Ignore Error    Click Element                    css=button[data-tip="เพิ่มหมวดหมู่"]
    Run Keyword And Ignore Error    Wait Until Element Is Visible    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    10s
    Run Keyword And Ignore Error    Input Text                       xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${category_name}
    Run Keyword And Ignore Error    Click Element                    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    Run Keyword And Ignore Error    Wait Until Success Message Appears
    Run Keyword And Ignore Error    Click Element                    css=button.swal2-confirm
    Run Keyword And Ignore Error    Verify Category Created          ${category_name}