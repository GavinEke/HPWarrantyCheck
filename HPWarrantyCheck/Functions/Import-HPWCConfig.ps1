Function Import-HPWCConfig {
    [CmdletBinding()]
    Param(
        [Parameter(HelpMessage = 'Optional non default path to config file')]
        [ValidateScript({$_ | Test-Path -PathType Leaf})]
        [System.IO.FileInfo]$Path = "$HOME\.HPWC\HPWCConfigurationFile.xml"
    )
    
    Begin {}

    Process {
        If (Test-Path -Path "$Path") {
            $HPWCConfigurationFile = Import-Clixml -Path "$Path"
            Write-Verbose -Message "HPWCConfigurationFile has been loaded from $Path"

            Try {             
                $Uri = 'https://css.api.hp.com/oauth/v1/token'
                $headers = @{'Content-Type' = 'application/x-www-form-urlencoded'}
                $body = 'apiKey={0}&apiSecret={1}&grantType={2}&scope={3}' -f $HPWCConfigurationFile.ConsumerKey, $HPWCConfigurationFile.ConsumerSecret, $HPWCConfigurationFile.GrantType, $HPWCConfigurationFile.Scope
                
                $Response = Invoke-RestMethod -Method Post -Uri $Uri -Headers $headers -Body $body

                $Script:BaseUri = 'https://css.api.hp.com/productWarranty/v1'
                $Script:AccessToken = "Bearer $($Response.Root.access_token)"
                $Script:headers = @{
                    'Authorization' = "$AccessToken";
                    'Cache-Control' = 'no-cache';
                    'Content-Type' = 'application/json'
                }
                $Script:ConfigImported = $True

            } Catch {
                $_.Exception.Message
            }
        }
        Else {
            Write-Warning -Message 'No Configuration File Found. Please run New-HPWCConfig to create a Configuration File.'
            $Script:ConfigImported = $False
        }
    }

    End {}
}
