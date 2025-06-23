*** Settings ***
Documentation     A resource file with reusable keywords and variables for register tests.
Library           SeleniumLibrary

*** Variables ***
${SERVER}         localhost:5173
${BROWSER}        chrome
${DELAY}          0.24
${REGISTER URL}   http://${SERVER}/register
${LOGIN URL}      http://${SERVER}/login
${WAIT_TIME}      10

*** Keywords ***
Open Browser To Register Page
    Open Browser    ${REGISTER URL}    ${BROWSER}
    Maximize Browser Window
    Set Selenium Speed    ${DELAY}
    Wait Until Page Contains Element    id=username    ${WAIT_TIME}
    Register Page Should Be Open

Register Page Should Be Open
    Title Should Be    Vite + React
    Location Should Be    ${REGISTER URL}

Go To Register Page
    Go To    ${REGISTER URL}
    Wait Until Page Contains Element    id=username    ${WAIT_TIME}
    Register Page Should Be Open

Input Username
    [Arguments]    ${username}
    Wait Until Element Is Visible    id=username    ${WAIT_TIME}
    Input Text    id=username    ${username}

Input Password
    [Arguments]    ${password}
    Wait Until Element Is Visible    id=password    ${WAIT_TIME}
    Input Text    id=password    ${password}

Input Confirm Password
    [Arguments]    ${password}
    Wait Until Element Is Visible    id=confirmPassword    ${WAIT_TIME}
    Input Text    id=confirmPassword    ${password}

Submit Registration
    Wait Until Element Is Visible    css=button[type='submit']    ${WAIT_TIME}
    Click Element    css=button[type='submit']

Registration Should Succeed
    Wait Until Location Is    ${LOGIN URL}    ${WAIT_TIME}
    Page Should Contain    ลงทะเบียนสำเร็จ

Registration Should Fail
    [Arguments]    ${error_message}
    Wait Until Location Is    ${REGISTER URL}    ${WAIT_TIME}
    IF    "${error_message}" == "Please fill out this field."
        # ถ้าเป็น validation message ให้ตรวจสอบว่ายังอยู่ที่หน้า register
        Location Should Be    ${REGISTER URL}
    ELSE
        # ถ้าเป็น error message อื่นๆ ให้ตรวจสอบข้อความ
        Wait Until Element Is Visible    css=.text-slate-700.text-sm.text-center.bg-red-50    ${WAIT_TIME}
        Element Should Contain    css=.text-slate-700.text-sm.text-center.bg-red-50    ${error_message}
    END

Password Mismatch Error Should Be Shown
    Wait Until Element Is Visible    css=.text-slate-700.text-sm.text-center.bg-red-50    ${WAIT_TIME}
    Element Should Contain    css=.text-slate-700.text-sm.text-center.bg-red-50    รหัสผ่านไม่ตรงกัน 