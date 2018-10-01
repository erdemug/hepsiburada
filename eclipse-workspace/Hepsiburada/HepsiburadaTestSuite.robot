*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Suite Setup    Set Browser Environment Variable   ${browser}
Test Teardown    Run Keyword If Test Failed    Error Case
*** Variables ***
${url}    https://www.hepsiburada.com/
${browser}    chrome
${driverdir}
${outputdir}
${id_desktop widget FiltersList}
${id_desktop widget SearchListing}
*** Test Cases ***
Test Case 1
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Element Should Be Visible    //*[@id="myAccount"]
    Click Element    //*[@id="myAccount"]
    Click Element    //*[@id="login"]
    Element Should Be Visible    //*[@id="form-login"]/div[4]/button    
    Input Text    //*[@id="email"]    testugurcan@gmail.com
    Input Password    //*[@id="password"]    Test1234hb
    Click Button    //*[@id="form-login"]/div[4]/button
    Wait Until Element Is Visible    //*[@id="myAccount"]/div[1]/a[1]
    Element Should Contain    //*[@id="myAccount"]/div[1]/a[1]    Ugurcan Test
    Input Text    //*[@id="productSearch"]    iphone 7 kilif
    Click Button    //*[@id="buttonProductSearch"]
    
    ${id_desktop widget FiltersList}=    Get Element Attribute     xpath=//*[@class="desktop widget FiltersList"]    id
    #desktop widget FiltersList classinin id'sini alarak her authenticationa ozel olusturulan id'yi otomatik almis olduk
    
    Log    ${id_desktop widget FiltersList}
    Click Element    //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[3]/label
    ${id_desktop widget SearchListing}=    Get Element Attribute     xpath=//*[@class="desktop widget SearchListing"]    id
    #desktop widget SearchListing classinin id'sini alarak her authenticationa ozel olusturulan id'yi otomatik almis olduk
   
    Log    ${id_desktop widget SearchListing}
    Wait Until Element Is Enabled    //*[@id="${id_desktop widget SearchListing}"]/div/div/ul/li[1]/div/a/div/span[2]/button
    Click Button    //*[@id="${id_desktop widget SearchListing}"]/div/div/ul/li[1]/div/a/div/span[2]/button
    Wait Until Element Is Visible    //*[@id="notification"]
    #ilk urunun eklendigi gorulur
    
    ${product1_data}=    Get Element Attribute     xpath=//*[@id="${id_desktop widget SearchListing}"]/div/div/ul/li[1]/div/a/div/span[2]/button    data-product
    Log     ${product1_data}
    #ilk urunun datasi alinir
    
    Wait Until Element Is Enabled    //*[@id="${id_desktop widget SearchListing}"]/div/div/ul/li[2]/div/a/div/span[2]/button
    Click Button    //*[@id="${id_desktop widget SearchListing}"]/div/div/ul/li[2]/div/a/div/span[2]/button
    Wait Until Element Is Visible    //*[@id="notification"]
    #ikinci urunun eklendigi gorulur
    
    ${product2_data}=    Get Element Attribute     xpath=//*[@id="${id_desktop widget SearchListing}"]/div/div/ul/li[2]/div/a/div/span[2]/button    data-product
    Log     ${product2_data}
    #ikinci urunun datasi alinir
    
    
    Wait Until Element Is Visible    //*[@id="CartButton"]
    Click Element    //*[@id="CartButton"]
    Location Should Be    https://www.hepsiburada.com/ayagina-gelsin/sepetim
    
    ${product1_name}=    Get Element Attribute    //*[@id="form-item-list"]/ul/li[1]/div/div[1]/h4/a    text
    ${product2_name}=    Get Element Attribute    //*[@id="form-item-list"]/ul/li[2]/div/div[1]/h4/a    text
    #her iki urunun sepetteki adlari alinir
    
    Should Contain    ${product1_data}    ${product1_name}    
    Should Contain    ${product2_data}    ${product2_name} 
    #alinan urun adlarinin datalarda oldugu kontrol edilir
    
    Click Button    //*[@id="short-summary"]/div[1]/div[2]/button
    Location Should Be    https://www.hepsiburada.com/ayagina-gelsin/teslimat
    Wait Until Element Is Visible    //*[@id="checkout-container"]
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   //*[@id="first-name"]
    Run Keyword If    ${present}    Add Address For the First Time
    Run Keyword Unless    ${present}    Choose Address
    #Add New Address ile degistirilebilir
    
    Click Element    //*[@id="delivery-container"]/div[2]/div[3]/ul/li/div/div[2]/ul/li[2]/div[2]/div[2]/div[1]/span[1]
    Click Element    //*[@id="delivery-container"]/div[2]/div[3]/ul/li/div/div[2]/ul/li[2]/div[3]/ul/li[3]/div[3]
    Click Button    //*[@id="short-summary"]/div[1]/div[2]/button
    Location Should Be    https://www.hepsiburada.com/ayagina-gelsin/odeme
    
    
    
        
*** Keywords ***
Set Browser Environment Variable
    [Arguments]    ${browser}
    [Documentation]    Verilen tarayici degiskenini tanimlamaya yarar. Tarayiciya gore driver calistirilir.
    ${date}=    Get Current Date    result_format=%d-%m-%Y %H-%M
    Set Suite Variable    ${outputdir}    C:/eclipse-workspace/Hepsiburada/${date}
    Run Keyword If    '${browser}'=='firefox'    Set Suite Variable    ${driverdir}    geckodriver.exe
    Run Keyword If    '${browser}'=='chrome'    Set Suite Variable    ${driverdir}    chromedriver.exe
    Set Environment Variable    webdriver.${browser}.driver    C:/eclipse-workspace/Hepsiburada/${driverdir}
    Set Selenium Speed    1 second
 
    
Error Case
    [Documentation]    Hatali olan test adimi sonrasi hata ekran goruntusunun tutulacagi dizin olusturulur ve ekran goruntusu alinir.
    Create Directory    ${outputdir}
    Set Screenshot Directory    ${outputdir}        
    Capture Page Screenshot    ${outputdir}/error.png
    #Close Browser
    
Add Address For the First Time
    Input Text    //*[@id="first-name"]    Ugurcan
    Input Text    //*[@id="last-name"]    Test
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[1]/div/div[1]/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[1]/div/div[1]/div/ul/li[154]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[2]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[2]/div/div[1]/div/ul/li[41]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[3]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[3]/div/div/div/ul/li[35]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[4]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[4]/div/div/div/ul/li[2]/a
    Input Text    //*[@id="address"]    Test Mahallesi Test Sokak 1/1
    Input Text    //*[@id="address-name"]    Evim
    Input Text    //*[@id="phone"]    5376181357
    
Choose Address
    Click Element    //*[@id="addresses"]/div/div[1]/div/div[1]/span
    Click Element    //*[@id="addresses"]/div/div[1]/div/div[2]/ul/li/a
    
Add New Address
    Click Element    //*[@id="addresses"]/div/div[1]/div/a
    Input Text    //*[@id="first-name"]    Ugurcan
    Input Text    //*[@id="last-name"]    Test
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[1]/div/div[1]/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[1]/div/div[1]/div/ul/li[154]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[2]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[2]/div/div[1]/div/ul/li[41]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[3]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[3]/div/div/div/ul/li[35]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[4]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[4]/div/div/div/ul/li[2]/a
    Input Text    //*[@id="address"]    Test Mahallesi Test Sokak 1/1
    Input Text    //*[@id="address-name"]    Evim
    Input Text    //*[@id="phone"]    5376181357
    Click Element    //*[@id="form-address"]/div/div/div[5]/div/button