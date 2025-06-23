*** Settings ***
Documentation     A test suite containing tests related to category management.
...               These tests are data-driven by their nature. They use a single
...               keyword, specified with Test Template setting, that is called
...               with different arguments to cover different scenarios.
...               
...               This suite also demonstrates using setups and teardowns in
...               different levels.
Suite Setup       Open Browser To Login Page
Suite Teardown    Close Browser
Test Setup        Go To Category Page
Test Template     Category Management Should Work
Resource          ../login_tests/resource.robot

*** Variables ***
${VALID_USERNAME}    perth1
${VALID_PASSWORD}    1234
${CATEGORY_NAME}    Test Category

*** Test Cases ***               ACTION          CATEGORY_NAME
Create Category                  create          ${CATEGORY_NAME} ${RANDOM_STRING}
Edit Category                    edit            Updated ${CATEGORY_NAME} ${RANDOM_STRING}
Delete Category                  delete          Updated ${CATEGORY_NAME} ${RANDOM_STRING}

*** Keywords ***
Go To Category Page
    Input Username    ${VALID_USERNAME}
    Input Password    ${VALID_PASSWORD}
    Submit Credentials
    Welcome Page Should Be Open
    Wait Until Page Contains Element    xpath=//span[contains(text(), 'จัดการ')]
    Click Element    xpath=//span[contains(text(), 'จัดการ')]
    Wait Until Page Contains Element    xpath=//a[contains(text(), 'จัดการประเภทสินค้า')]
    Click Element    xpath=//a[contains(text(), 'จัดการประเภทสินค้า')]
    Wait Until Page Contains Element    xpath=//h2[contains(text(), 'ประเภทสินค้า')]

Category Management Should Work
    [Arguments]    ${action}    ${category_name}
    Run Keyword If    '${action}' == 'create'    Create New Category    ${category_name}
    ...    ELSE IF    '${action}' == 'edit'    Edit Existing Category    ${category_name}
    ...    ELSE IF    '${action}' == 'delete'    Delete Category    ${category_name}

Create New Category
    [Arguments]    ${category_name}
    Click Element    xpath=//button[@data-tip='เพิ่มหมวดหมู่']
    Wait Until Element Is Visible    xpath=//input[@placeholder='ชื่อประเภทสินค้า']
    Input Text    xpath=//input[@placeholder='ชื่อประเภทสินค้า']    ${category_name}
    Click Element    xpath=//button[contains(text(), 'บันทึกข้อมูล')]
    Wait Until Element Is Visible    xpath=//div[contains(@class, 'swal2-success')]
    Verify Category Created    ${category_name}

Edit Existing Category
    [Arguments]    ${category_name}
    Click Edit Category Button    ${category_name}
    Input Category Name    Updated ${category_name}
    Click Save Category Button
    Wait Until Success Message Appears
    Verify Category Updated    Updated ${category_name}

Delete Category
    [Arguments]    ${category_name}
    Click Delete Category Button    ${category_name}
    Confirm Delete Category
    Wait Until Success Message Appears
    Verify Category Deleted    ${category_name}

Click Create Category Button
    Click Element    xpath=//button[contains(text(), 'เพิ่มประเภทสินค้า')]
    Wait Until Element Is Visible    xpath=//h2[contains(text(), 'ข้อมูลประเภทสินค้า')]

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

Click Edit Category Button
    [Arguments]    ${name}
    Click Element    xpath=//td[contains(text(), '${name}')]/following-sibling::td//button[contains(@class, 'edit')]

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