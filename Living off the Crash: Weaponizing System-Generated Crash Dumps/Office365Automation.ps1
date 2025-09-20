# Define User Credentials
$O365Username = <Microsoft 365 Login>
$O365Password = <Password>

# Load Selenium module
Import-Module Selenium

#Setup GeckoDriver
$geckoDriverPath = "C:\ProgramData\chocolatey\bin"
$firefoxOptions = New-Object OpenQA.Selenium.Firefox.FirefoxOptions
$firefoxProfilePath = "$env:APPDATA\Mozilla\Firefox\Profiles"
$firefoxDefaultProfile = Get-ChildItem $firefoxProfilePath | Where-Object { $_.Name -like "*.default*" } | Select-Object -First 1
$firefoxFullProfilePath = "$firefoxProfilePath\$($firefoxDefaultProfile.Name)"
$firefoxOptions.AddArgument("-profile")
$firefoxOptions.AddArgument($firefoxFullProfilePath)

#Setup ChromeDriver
$chromeDriverPath = "C:\ProgramData\chocolatey\bin"
$chromeOptions = New-Object OpenQA.Selenium.Chrome.ChromeOptions

# Use local user Chrome profile
$chromeProfilePath = "$env:LOCALAPPDATA\Google\Chrome\User Data"
$chromeOptions.AddArgument("--user-data-dir=$chromeProfilePath")
$chromeOptions.AddArgument("--profile-directory=Default")

# Execute Firefox Automation
$firefoxDriver = New-Object OpenQA.Selenium.Firefox.FirefoxDriver($geckoDriverPath, $firefoxOptions)
$firefoxDriver.Navigate().GoToUrl("https://mail.office365.com")
Start-Sleep -Seconds 3 # Give page time to load 
$firefoxEmailField = $firefoxDriver.FindElementById("i0116")  #Sends Username
$firefoxEmailField.Clear()
$firefoxEmailField.SendKeys($O365Username)
Start-Sleep -Seconds 2 # Sleeps for input completion and click "Next" button
$firefoxNextButton = $firefoxDriver.FindElementById("idSIButton9")
$firefoxNextButton.Click()
Start-Sleep -Seconds 3 #Wait for password field and enter password
$firefoxPasswordField = $firefoxDriver.FindElementById("i0118")
$firefoxPasswordField.SendKeys($O365Password)
Start-Sleep -Seconds 2 # Sleep for input completion and click "Sign In"
$firefoxSignInButton = $firefoxDriver.FindElementById("idSIButton9")
$firefoxSignInButton.Click()
Start-Sleep -Seconds 3  # Wait for the prompt to appear. Click "No" on Stay Signed In prompt
$firefoxStaySignedInNoButton = $firefoxDriver.FindElementById("idBtn_Back")
$firefoxStaySignedInNoButton.Click()

#Execute Chrome Automation
$chromeDriver = New-Object OpenQA.Selenium.Chrome.ChromeDriver($chromeDriverPath, $chromeOptions)
$chromeDriver.Navigate().GoToUrl("https://mail.office365.com")
Start-Sleep -Seconds 3 # Give page time to load 
$chromeEmailField = $chromeDriver.FindElementById("i0116")  #Sends Username
$chromeEmailField.Clear()
$chromeEmailField.SendKeys($O365Username)
Start-Sleep -Seconds 2 # Sleeps for input completion and click "Next" button
$chromeNextButton = $chromeDriver.FindElementById("idSIButton9")
$chromeNextButton.Click()
Start-Sleep -Seconds 3 #Wait for password field and enter password
$chromePasswordField = $chromeDriver.FindElementById("i0118")
$chromePasswordField.SendKeys($O365Password)
Start-Sleep -Seconds 2 # Sleep for input completion and click "Sign In"
$chromeSignInButton = $chromeDriver.FindElementById("idSIButton9")
$chromeSignInButton.Click()
Start-Sleep -Seconds 3  # Wait for the prompt to appear. Click "No" on Stay Signed In prompt
$chromeStaySignedInNoButton = $chromeDriver.FindElementById("idBtn_Back")
$chromeStaySignedInNoButton.Click() 
 

