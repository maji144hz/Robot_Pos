*** Settings ***
Documentation     A test suite with a single test for valid registration.
Resource          resource.robot

*** Test Cases ***
Valid Registration
    Open Browser To Register Page
    Input Username    testuser1
    Input Password    1234
    Input Confirm Password    1234
    Submit Registration
    Registration Should Succeed
    [Teardown]    Close Browser 