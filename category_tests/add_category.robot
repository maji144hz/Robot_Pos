*** Settings ***
Documentation     Test suite for category management with login required.
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Login And Go To Category Page
Resource          ../login_tests/resource.robot

*** Variables ***
${VALID_USERNAME}    zzz
${VALID_PASSWORD}    zz12zz
${CATEGORY_BASE}     Test Category
${RANDOM}            ${random.randint(1000, 9999)}

*** Test Cases ***
Create Category With Unique Name
    [Tags]    create
    ${category_name}=    Set Variable    ${CATEGORY_BASE} ${RANDOM}
    Create New Category    ${category_name}
    Verify Category Created    ${category_name}

Create Category With Duplicate Name Should Fail
    [Tags]    create    negative
    ${category_name}=    Set Variable    ${CATEGORY_BASE} ${RANDOM}
    Create New Category    ${category_name}
    Create New Category    ${category_name}
    Wait Until Page Contains    มีหมวดหมู่นี้อยู่ในระบบแล้ว

Edit Category Name
    [Tags]    edit
    ${category_name}=    Set Variable    ${CATEGORY_BASE} ${RANDOM}
    Create New Category    ${category_name}
    ${updated_name}=    Set Variable    Updated ${category_name}
    Edit Existing Category    ${category_name}    ${updated_name}
    Verify Category Updated    ${updated_name}

Delete Category
    [Tags]    delete
    ${category_name}=    Set Variable    ${CATEGORY_BASE} ${RANDOM}
    Create New Category    ${category_name}
    Delete Category    ${category_name}
    Verify Category Deleted    ${category_name}

Create Category Without Login Should Fail
    [Tags]    negative    auth
    Logout
    Go To Category Page Without Login
    Wait Until Page Contains    กรุณาเข้าสู่ระบบ

*** Keywords ***
Login And Go To Category Page
    Input Username    ${VALID_USERNAME}
    Input Password    ${VALID_PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Go To Category Page

Go To Category Page
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'จัดการ')]
    Click Element    xpath=//span[contains(text(), 'จัดการ')]
    Wait Until Page Contains Element    xpath=//a[contains(text(), 'จัดการประเภทสินค้า')]
    Click Element    xpath=//a[contains(text(), 'จัดการประเภทสินค้า')]
    Wait Until Page Contains Element    xpath=//h2[contains(text(), 'ประเภทสินค้า')]
     Click Element    xpath=//button[contains(@class, 'fixed') and @data-tip="เพิ่มหมวดหมู่"]

Go To Category Page Without Login
    Go To    ${URL}/management/categories

Create New Category
    [Arguments]    ${category_name}
    Wait Until Element Is Visible    css=button[data-tip="เพิ่มหมวดหมู่"]    10s
    Execute JavaScript    window.scrollTo(0, document.body.scrollHeight)
    Sleep    1s
    Click Element    css=button[data-tip="เพิ่มหมวดหมู่"]
    Wait Until Element Is Visible    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    10s
    Input Text    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${category_name}
    Click Element    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-success')]    10s

Edit Existing Category
    [Arguments]    ${old_name}    ${new_name}
    Click Edit Category Button    ${old_name}
    Input Category Name    ${new_name}
    Click Save Category Button
    Wait Until Success Message Appears

Delete Category
    [Arguments]    ${category_name}
    Click Delete Category Button    ${category_name}
    Confirm Delete Category
    Wait Until Success Message Appears

Click Edit Category Button
    [Arguments]    ${name}
    Click Element    xpath=//td[contains(text(), '${name}')]/following-sibling::td//button[contains(@class, 'edit')]

Input Category Name
    [Arguments]    ${name}
    Input Text    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${name}

Click Save Category Button
    Click Element    xpath=//button[contains(text(), 'บันทึกข้อมูล')]

Wait Until Success Message Appears
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-success')]

Verify Category Created
    [Arguments]    ${name}
    Wait Until Page Contains Element    xpath=//td[contains(text(), '${name}')]

Verify Category Updated
    [Arguments]    ${name}
    Wait Until Page Contains Element    xpath=//td[contains(text(), '${name}')]

Click Delete Category Button
    [Arguments]    ${name}
    Click Element    xpath=//td[contains(text(), '${name}')]/following-sibling::td//button[contains(@class, 'delete')]

Confirm Delete Category
    Click Element    xpath=//button[contains(text(), 'ยืนยัน')]

Verify Category Deleted
    [Arguments]    ${name}
    Wait Until Page Does Not Contain Element    xpath=//td[contains(text(), '${name}')]

Logout
    Click Element    xpath=//button[contains(@class, 'logout')]
    Wait Until Page Contains    กรุณาเข้าสู่ระบบ