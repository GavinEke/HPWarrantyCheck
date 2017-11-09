Function Get-HPWCWarranyInfo {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True, HelpMessage = 'The serial number of the HP device.')]
        [Alias('sn')]
        [ValidateLength(3, 120)]
        [String]$SerialNumber,

        [Parameter(Mandatory = $True, HelpMessage = 'The product number of the HP device.')]
        [Alias('pn')]
        [ValidateLength(3, 120)]
        [String]$ProductNumber
    )
    
    Begin {
        If (-not ($AccessToken)) {Import-HPWCConfig}
    }

    Process {
        If ($ConfigImported) {
            Try {
                $Uri = "$BaseUri/queries"
                $json = @{
                    'sn' = $SerialNumber;
                    'pn' = $ProductNumber
                }
                $body = "[$($json | ConvertTo-Json)]"
                $Response = Invoke-RestMethod -Method Post -Uri $Uri -Headers $headers -Body $body
                $Response

            } Catch {
                $_.Exception.Message
            }
        }
    }

    End {}
}
