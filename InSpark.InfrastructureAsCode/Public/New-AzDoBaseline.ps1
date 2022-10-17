function New-AzDoBaseline {
    <#
.SYNOPSIS
    Creates the Azure DevOps baseline.
.DESCRIPTION
    Creates the Azure DevOps baseline.
.EXAMPLE
    New-AzDoBaseline

    This example will create
.OUTPUTS
    PSobject containing the display name, ID and description.
.NOTES
#>
    [CmdletBinding(SupportsShouldProcess, DefaultParameterSetName = 'BySubscriptionName')]
    param (
        # Tenant ID of the destination's project.
        [Parameter(Mandatory)]
        [string]
        $TenantId,

        # Subscription ID for the App Registration.
        [Parameter(Mandatory)]
        [string]
        $SubscriptionId,

        # Subscription name for the App Registration.
        [Parameter(Mandatory)]
        [string]
        $SubscriptionName,

        # Name of the App Registration to be used for the service connection.
        [Parameter(Mandatory)]
        [string]
        $AppRegistrationName,

        # Name of the organization where the repositories to be cloned live.
        [Parameter()]
        [string]
        $SourceOrganizationName = 'WeAreInSpark',

        # Name of the project where the repositories to be cloned live.
        [Parameter()]
        [string]
        $SourceProjectName = 'CIA',

        # PAT to get access to the source organization.
        [Parameter()]
        [string]
        $SourcePAT = $env:SYSTEM_ACCESSTOKEN,

        # Name of the organization where the baseline will be set up.
        [Parameter(Mandatory)]
        [string]
        $DestinationOrganizationName,

        # Name of the project where the baseline will be set up.
        [Parameter(Mandatory)]
        [string]
        $DestinationProjectName,

        # PAT to get access to the destination organization.
        [Parameter(Mandatory)]
        [string]
        $DestinationPAT,

        # Name of the Key Vault for the App Registration certificate.
        [Parameter(Mandatory)]
        [string]
        $KeyVaultName,

        # Switch to create a new project in the destiniation organization.
        [Parameter()]
        [bool]
        $NewProject = $true,

        # Switch to create new repositories in the destiniation project.
        [Parameter()]
        [bool]
        $NewRepo = $true,

        # Switch to perform a mirror clone, which also clones branches and tags.
        [Parameter()]
        [bool]
        $Mirror = $false
    )
    $SourceOrganizationName = 'WeAreInSpark'
    $SourcePAT = 'o4exieba6irbbsaezqfshtz3xouseihr4rmo6y7rmcydatpumypa'
    $SourceProjectName = 'CIA'
    $DestinationOrganizationName = 'LucasBahnmuller0751'
    $DestinationPAT = '7r4xzhc6m5jcsixkvkqafu43y7fla22hrnjem4jrclfylrg2bdca'
    $DestinationProjectName = 'TestProject'
    $SubscriptionName = 'Generic - Team DNA'
    $SubscriptionId = '1e95b10c-266b-4d4f-9be2-856a3bb1462e'
    $TenantId = 'cd004ec9-bc4b-4721-82df-cd3a2e134a09'
    $KeyVaultName = 'kv-lucas-test'
    $AppRegistrationName = 'lucastestscript'
    $NewProject = $true
    $NewRepo = $true
    $Mirror = $false

    # Connect-AzAccount -tenantid $TenantId
    # Set-AzContext $SubscriptionName

    # Create project
    if ($NewProject) {
        $newAzDoProjectSplat = @{
            CollectionUri = "https://dev.azure.com/$DestinationOrganizationName"
            PAT           = $DestinationPAT
            ProjectName   = $DestinationProjectName
        }
        $ProjectId = (New-AzDoProject @newAzDoProjectSplat).Id

        $setAzDoProjectSettingsSplat = @{
            CollectionUri = "https://dev.azure.com/$DestinationOrganizationName"
            PAT           = $DestinationPAT
            ProjectName   = $DestinationProjectName
        }
        Set-AzDoProjectSettings @setAzDoProjectSettingsSplat | Format-List
    }

    # Get Project ID
    if (-not($NewProject)) {
        $params = @{
            uri         = "https://dev.azure.com/$DestinationOrganizationName/_apis/projects?api-version=6.0"
            Method      = 'GET'
            Headers     = @{Authorization = 'Basic ' + [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$($DestinationPAT)")) }
            ContentType = 'application/json'
        }
        $Projects = Invoke-RestMethod @params
        $ProjectId = ($Projects.value | Where-Object name -EQ $DestinationProjectName).id
    }

    # Service connection
    $AppRegistration = New-AadAppRegistration -Name $AppRegistrationName

    $newAadAppRegistrationCertificateSplat = @{
        ObjectID     = $AppRegistration.Id
        CertName     = $DestinationProjectName
        KeyVaultName = $KeyVaultName
        SubjectName  = "$DestinationProjectName.com"
    }
    New-AadAppRegistrationCertificate @newAadAppRegistrationCertificateSplat | Format-List

    $newAzDoServiceConnectionSplat = @{
        Name               = $SubscriptionName
        CollectionUri      = "https://dev.azure.com/$DestinationOrganizationName"
        PAT                = $DestinationPAT
        ProjectName        = $DestinationProjectName
        ProjectID          = $ProjectId
        Description        = "Demo test connection"
        ScopeLevel         = 'Subscription'
        SubscriptionId     = $SubscriptionId
        SubscriptionName   = $SubscriptionName
        Tenantid           = $TenantId
        Serviceprincipalid = '1ab217fe-1d72-4934-8ea5-32712880e92f'
        AuthenticationType = 'spnCertificate'
        KeyVaultName       = $KeyVaultName
        CertName           = $newAadAppRegistrationCertificateSplat.CertName
    }
    New-AzDoServiceConnection @newAzDoServiceConnectionSplat | Format-List

    $addAzDoPermissionSplat = @{
        CollectionUri           = "https://dev.azure.com/$DestinationOrganizationName"
        ProjectId               = $ProjectId
        PAT                     = $DestinationPAT
        RoleName                = 'Administrator'
        AllServiceConnections   = $true
        BuildServicePermissions = $true
    }
    Add-AzDoPermission @addAzDoPermissionSplat

    # Repo splats
    $newAzDoRepoCloneSplat = @{
        SourceOrganizationName      = $SourceOrganizationName
        SourcePAT                   = $SourcePAT
        SourceProjectName           = $SourceProjectName
        DestinationOrganizationName = $DestinationOrganizationName
        DestinationPAT              = $DestinationPAT
        DestinationProjectName      = $DestinationProjectName
        NewRepo                     = $NewRepo
        Mirror                      = $Mirror
    }

    $newAzDoPipelineSplat = @{
        CollectionUri = "https://dev.azure.com/$DestinationOrganizationName"
        Name          = $PipelineName
        ProjectName   = $DestinationProjectName
        PAT           = $DestinationPAT
    }

    $newAzDoVariableGroupSplat = @{
        CollectionUri = "https://dev.azure.com/$DestinationOrganizationName"
        PAT           = $DestinationPAT
        ProjectName   = $DestinationProjectName
    }

    ### Foundation
    $SourceRepoName = 'Foundation'
    $DestinationRepoName = 'Foundation'
    $PipelineName = 'Foundation'
    $VariableGroupName = 'Foundation'

    $RepoId = (New-AzDoRepoClone @newAzDoRepoCloneSplat -SourceRepoName $SourceRepoName -DestinationRepoName $DestinationRepoName).id
    New-AzDoPipeline @newAzDoPipelineSplat -Name $PipelineName -RepoName $DestinationRepoName

    $Variables = @{
        RepoId    = $RepoId
        ProjectId = $ProjectId
    }
    New-AzDoVariableGroup @newAzDoVariableGroupSplat -Name $VariableGroupName -Variables $Variables

    $addAzDoPermissionSplat = @{
        CollectionUri           = "https://dev.azure.com/$DestinationOrganizationName"
        ProjectId               = $ProjectId
        PAT                     = $DestinationPAT
        RoleName                = 'Administrator'
        VariableGroupName       = $VariableGroupName
        BuildServicePermissions = $true
    }
    Add-AzDoPermission @addAzDoPermissionSplat

    ### PlatformConnectivity
    $SourceRepoName = 'PlatformConnectivity'
    $DestinationRepoName = 'PlatformConnectivity'
    $PipelineName = 'PlatformConnectivity'
    $VariableGroupName = 'Platform-Connectivity-Weu'

    $RepoId = (New-AzDoRepoClone @newAzDoRepoCloneSplat -SourceRepoName $SourceRepoName -DestinationRepoName $DestinationRepoName).id
    New-AzDoPipeline @newAzDoPipelineSplat -Name $PipelineName -RepoName $DestinationRepoName

    $Variables = @{
        RepoId    = $RepoId
        ProjectId = $ProjectId
    }
    New-AzDoVariableGroup @newAzDoVariableGroupSplat -Name $VariableGroupName -Variables $Variables

    $addAzDoPermissionSplat = @{
        CollectionUri           = "https://dev.azure.com/$DestinationOrganizationName"
        ProjectId               = $ProjectId
        PAT                     = $DestinationPAT
        RoleName                = 'Administrator'
        VariableGroupName       = $VariableGroupName
        BuildServicePermissions = $true
    }
    Add-AzDoPermission @addAzDoPermissionSplat

    ### PlatformIdentity
    $SourceRepoName = 'PlatformIdentity'
    $DestinationRepoName = 'PlatformIdentity'
    $PipelineName = 'PlatformIdentity'
    $VariableGroupName = 'Platform-Identity-Weu'

    $RepoId = (New-AzDoRepoClone @newAzDoRepoCloneSplat -SourceRepoName $SourceRepoName -DestinationRepoName $DestinationRepoName).id
    New-AzDoPipeline @newAzDoPipelineSplat -Name $PipelineName -RepoName $DestinationRepoName

    $Variables = @{
        RepoId    = $RepoId
        ProjectId = $ProjectId
    }
    New-AzDoVariableGroup @newAzDoVariableGroupSplat -Name $VariableGroupName -Variables $Variables

    $addAzDoPermissionSplat = @{
        CollectionUri           = "https://dev.azure.com/$DestinationOrganizationName"
        ProjectId               = $ProjectId
        PAT                     = $DestinationPAT
        RoleName                = 'Administrator'
        VariableGroupName       = $VariableGroupName
        BuildServicePermissions = $true
    }
    Add-AzDoPermission @addAzDoPermissionSplat

    ### PlatformManagement
    $SourceRepoName = 'PlatformManagement'
    $DestinationRepoName = 'PlatformManagement'
    $PipelineName = 'PlatformManagement'
    $VariableGroupName = 'Platform-Management-Weu'

    $RepoId = (New-AzDoRepoClone @newAzDoRepoCloneSplat -SourceRepoName $SourceRepoName -DestinationRepoName $DestinationRepoName).id
    New-AzDoPipeline @newAzDoPipelineSplat -Name $PipelineName -RepoName $DestinationRepoName

    $Variables = @{
        RepoId    = $RepoId
        ProjectId = $ProjectId
    }
    New-AzDoVariableGroup @newAzDoVariableGroupSplat -Name $VariableGroupName -Variables $Variables

    $addAzDoPermissionSplat = @{
        CollectionUri           = "https://dev.azure.com/$DestinationOrganizationName"
        ProjectId               = $ProjectId
        PAT                     = $DestinationPAT
        RoleName                = 'Administrator'
        VariableGroupName       = $VariableGroupName
        BuildServicePermissions = $true
    }
    Add-AzDoPermission @addAzDoPermissionSplat
}
