*** Settings ***
Library    SeleniumLibrary
Library    OperatingSystem
Library    DateTime
Resource    resource_file.txt
Suite Setup    Set Browser Environment Variable   ${browser}
Test Teardown    Run Keyword If Test Failed    Error Case
*** Variables ***
${driverdir}
${outputdir}
${id_desktop widget FiltersList}
${id_desktop widget SearchListing}
*** Test Cases ***
Test Case 1
    Open Browser    ${url}    ${browser}
    Maximize Browser Window
    Login    ${email}    ${password}    ${user_fullname}
    #Login keywordunde email adresi, sifre ve kullanici ismi yazilir
    Input Text    //*[@id="productSearch"]    ${search}    #arama alanina text girisi yapilir
    Click Button    //*[@id="buttonProductSearch"]    #ara butonuna basilir
    
    Filter Handle    Teslimat
    #Hangi filtre secilmek isteniyorsa argumanda o filtrenin textinde gecen bir kelimenin aranmasi yeterlidir. 
    #Bu ornekte Bugun Teslimat istenmistir.
    
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
    Click Element    //*[@id="CartButton"]    #Sepetim butonuna tiklanir
    Location Should Be    https://www.hepsiburada.com/ayagina-gelsin/sepetim    #Sepetim sayfasinda olundugu gorulur
    
    ${product1_name}=    Get Element Attribute    //*[@id="form-item-list"]/ul/li[1]/div/div[1]/h4/a    text
    ${product2_name}=    Get Element Attribute    //*[@id="form-item-list"]/ul/li[2]/div/div[1]/h4/a    text
    #her iki urunun sepetteki adlari alinir
    
    Should Contain    ${product1_data}    ${product1_name}    
    Should Contain    ${product2_data}    ${product2_name} 
    #alinan urun adlarinin datalarda oldugu kontrol edilir
    
    Click Button    //*[@id="short-summary"]/div[1]/div[2]/button    #Alisverisi Tamamla butonuna tiklanir
    Location Should Be    https://www.hepsiburada.com/ayagina-gelsin/teslimat    #Teslimat sayfasinin acildigi kontrol edilir
    Wait Until Element Is Visible    //*[@id="checkout-container"]    #Teslimat bilgilerinin geldigi kontrol edilir
    
    ${present}=  Run Keyword And Return Status    Element Should Be Visible   //*[@id="first-name"]
    Run Keyword If    ${present}    Add Address For the First Time    Ugurcan    Test    Test Mahallesi Test Sokak 1/1    Evim    5376181357
    Run Keyword Unless    ${present}    Choose Address    Evim
    #Ad-Soyad alani gorunmekteyse Add Address For the First Time komutu ile ilk kez adres olusturulur.
    #Eger ad soyad alani yerine Teslimat Adresi hazir geldiyse Choose Address komutu ile checkboxtan secilir
    #Eger yeni adres eklenmek istenirse Add New Address yazilabilir
    
    Click Element    //*[@id="delivery-container"]/div[2]/div[3]/ul/li/div/div[2]/ul/li[2]/div[2]/div[2]/div[1]/span[1]
    Click Element    //*[@id="delivery-container"]/div[2]/div[3]/ul/li/div/div[2]/ul/li[2]/div[3]/ul/li[3]/div[3]
    Click Button    //*[@id="short-summary"]/div[1]/div[2]/button
    Location Should Be    https://www.hepsiburada.com/ayagina-gelsin/odeme
    
    
    
        
*** Keywords ***
Set Browser Environment Variable
    [Arguments]    ${browser}
    [Documentation]    Verilen tarayici degiskenini tanimlamaya yarar. Tarayiciya gore driver calistirilir.
    ${date}=    Get Current Date    result_format=%d-%m-%Y %H-%M
    Set Suite Variable    ${outputdir}    ${EXECDIR}/${date}
    Run Keyword If    '${browser}'=='firefox'    Set Suite Variable    ${driverdir}    geckodriver.exe
    Run Keyword If    '${browser}'=='chrome'    Set Suite Variable    ${driverdir}    chromedriver.exe
    Set Environment Variable    webdriver.${browser}.driver    ${EXECDIR}/${driverdir}
    Set Selenium Speed    1 second

Login
    [Arguments]    ${email}    ${password}    ${user_fullname}
    [Documentation]    Login yapilacak email adresi, HB hesabi sifresi ve login check yapilabilmesi icin kullanici ismi istenmektedir.
    Element Should Be Visible    //*[@id="myAccount"]
    Click Element    //*[@id="myAccount"]
    Click Element    //*[@id="login"]
    Element Should Be Visible    //*[@id="form-login"]/div[4]/button    
    Input Text    //*[@id="email"]    ${email}
    Input Password    //*[@id="password"]    ${password}
    Click Button    //*[@id="form-login"]/div[4]/button
    Wait Until Element Is Visible    //*[@id="myAccount"]/div[1]/a[1]
    Element Should Contain    //*[@id="myAccount"]/div[1]/a[1]    ${user_fullname}
    
Error Case
    [Documentation]    Hatali olan test adimi sonrasi hata ekran goruntusunun tutulacagi dizin olusturulur ve ekran goruntusu alinir.
    Create Directory    ${outputdir}
    Set Screenshot Directory    ${outputdir}        
    Capture Page Screenshot    ${outputdir}/error.png
    #Close Browser
    
Add Address For the First Time
    [Arguments]    ${name}    ${surname}    ${address}    ${tag}    ${phone}
    [Documentation]    Sirasiyla isim, soyisim, adres, adres adi ve telefon no eklenir.
    Input Text    //*[@id="first-name"]    ${name}
    Input Text    //*[@id="last-name"]    ${surname}
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[1]/div/div[1]/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[1]/div/div[1]/div/ul/li[154]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[2]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[2]/div/div[1]/div/ul/li[41]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[3]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[3]/div/div/div/ul/li[35]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[4]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[4]/div/div/div/ul/li[2]/a
    Input Text    //*[@id="address"]    ${address}
    Input Text    //*[@id="address-name"]    ${tag}
    Input Text    //*[@id="phone"]    ${phone}
    
Choose Address
    [Arguments]    ${tag}
    Click Element    //*[@id="addresses"]/div/div[1]/div/div[1]/span
    Click Element     //*[contains(text(),'${tag}')]
    
Add New Address
    [Arguments]    ${name}    ${surname}    ${address}    ${tag}    ${phone}
    [Documentation]    Sirasiyla isim, soyisim, adres, adres adi ve telefon no eklenir.
    Click Element    //*[@id="addresses"]/div/div[1]/div/a
    Input Text    //*[@id="first-name"]    ${name} 
    Input Text    //*[@id="last-name"]    ${surname}
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[1]/div/div[1]/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[1]/div/div[1]/div/ul/li[154]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[2]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[2]/div/div[1]/div/ul/li[41]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[3]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[3]/div/div/div/ul/li[35]/a
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[4]/div/div/button/span[1]
    Click Element    //*[@id="form-address"]/div/div/section[2]/div[4]/div/div/div/ul/li[2]/a
    Input Text    //*[@id="address"]    ${address}
    Input Text    //*[@id="address-name"]    ${tag}
    Input Text    //*[@id="phone"]    ${phone}
    Click Element    //*[@id="form-address"]/div/div/div[5]/div/button
    
Filter Handle
    [Arguments]    ${arg}    
    [Documentation]    Hangi filtrenin kullanilmasini istiyorsak o filtrenin adi ile arama yapilir ve o filtrenin secilmesi saglanir
    ${id_desktop widget FiltersList}=    Get Element Attribute     xpath=//*[@class="desktop widget FiltersList"]    id
    #desktop widget FiltersList classinin id'sini alarak her authenticationa ozel olusturulan id'yi otomatik almis olduk
    
    Log    ${id_desktop widget FiltersList}
    ${filtername1}=    Get Element Attribute    //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[1]    title
    Log    ${filtername1}
    ${filtername2}=    Get Element Attribute    //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[2]    title
    Log    ${filtername2}
    ${filtername3}=    Get Element Attribute    //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[3]    title
    Log    ${filtername3}
    ${filtername4}=    Get Element Attribute    //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[4]    title
    Log    ${filtername4}
    ${filtername5}=    Get Element Attribute    //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[5]    title
    Log    ${filtername5}
    
    ${present}=  Run Keyword And Return Status    Should Contain   ${filtername1}    ${arg}    
    Run Keyword If    ${present}    Click Element     //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[1]
    ${present}=  Run Keyword And Return Status    Should Contain   ${filtername2}    ${arg}    
    Run Keyword If    ${present}    Click Element     //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[2]
    ${present}=  Run Keyword And Return Status    Should Contain   ${filtername3}    ${arg}
    Run Keyword If    ${present}    Click Element     //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[3]
    ${present}=  Run Keyword And Return Status    Should Contain   ${filtername4}    ${arg}
    Run Keyword If    ${present}    Click Element     //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[4]
    ${present}=  Run Keyword And Return Status    Should Contain   ${filtername5}    ${arg}
    Run Keyword If    ${present}    Click Element     //*[@id="${id_desktop widget FiltersList}"]/div/ol/li[4]/ol/li[5]  
    

