Function New-HPWCConfig {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory = $True, HelpMessage = 'Client key on https://developers.hp.com/user/me/my-apps')]
        [ValidateLength(3, 120)]
        [String]$ApiKey,

        [Parameter(Mandatory = $True, HelpMessage = 'Client secret on https://developers.hp.com/user/me/my-apps')]
        [ValidateLength(3, 120)]
        [String]$ApiSecret,

        [Parameter(HelpMessage = 'Optional non default path to config file')]
        [ValidateNotNullOrEmpty()]
        [String]$Path = "$HOME\.HPWC\HPWCConfigurationFile.xml"
    )

    Begin {
        $HPWCConfDir = Split-Path -Path "$Path"
        If (-not (Test-Path -Path "$HPWCConfDir")) {
            New-Item "$HPWCConfDir" -ItemType Directory | Out-Null
            Write-Verbose -Message "Creating folder $HPWCConfDir"
        }
    }

    Process {
        $HPWCConfigurationFile = @{ConsumerKey = $ApiKey; ConsumerSecret = $ApiSecret; GrantType = 'client_credentials'; Scope = 'warranty'}
        $HPWCConfigurationFile | Export-Clixml -Path "$Path" -Force
        Write-Verbose -Message "HPWCConfigurationFile has been written to $Path"
    }

    End {}
}
