*** Settings ***
Documentation     A test suite containing tests related to invalid registration.
Suite Setup       Open Browser To Register Page
Suite Teardown    Close Browser
Test Setup        Go To Register Page
Test Template     Register With Invalid Data Should Fail
Resource          resource.robot

*** Test Cases ***               USERNAME    PASSWORD    CONFIRM_PASSWORD    ERROR_MESSAGE
Empty Username                   ${EMPTY}    1234        1234               Please fill out this field.
Empty Password                   testuser    ${EMPTY}    ${EMPTY}           Please fill out this field.
Password Mismatch               testuser    1234        5678               รหัสผ่านไม่ตรงกัน
All Fields Empty               ${EMPTY}    ${EMPTY}    ${EMPTY}           Please fill out this field.
Username is already taken        testuser1   1234        1234             Username is already taken
*** Keywords ***
Register With Invalid Data Should Fail
    [Arguments]    ${username}    ${password}    ${confirm_password}    ${error_message}
    Input Username    ${username}
    Input Password    ${password}
    Input Confirm Password    ${confirm_password}
    Submit Registration
    Registration Should Fail    ${error_message} 