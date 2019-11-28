*** Settings ***

Resource        robot/Cumulus/resources/NPSP.robot
Suite Setup     Open Test Browser
Suite Teardown  Delete Records and Close Browser

 
*** Test Cases ***    
Create ASC for Primary Contact on Organization Gift
    [tags]  unstable
    &{account} =  API Create Organization Account   
    &{contact} =  API Create Contact    Email=skristem@robot.com 
    ${ns} =  Get NPSP Namespace Prefix
    &{opportunity} =  API Create Opportunity    &{account}[Id]    Donation    Name=&{account}[Name] $50 donation    Amount=50    ${ns}Primary_Contact__c=&{contact}[Id]
    Go To Record Home    &{opportunity}[Id]
    Select Tab    Related
    Select Relatedlist    Contact Roles
    Verify Related List Field Values
    ...                     &{contact}[FirstName] &{contact}[LastName]=Soft Credit
    Go To Record Home    &{contact}[Id]
    Select Tab    Related
    Load Related List    Opportunities
    Check Record Related Item    Opportunities    &{opportunity}[Name]
    Run Donations Batch Process
    Go To Record Home    &{Contact}[Id]
    ${locator}    Get NPSP Locator    detail_page.section_header    Soft Credit Total
    Scroll Element Into View    ${locator}
    Confirm Field Value    Soft Credit This Year    $50.00    Y
    Confirm Field Value    Soft Credit Total    $50.00    Y
