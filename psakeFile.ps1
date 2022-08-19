properties {
    # Set this to $true to create a module with a monolithic PSM1
    $PSBPreference.Build.CompileModule = $false
    $PSBPreference.Help.DefaultLocale = 'en-US'
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
}

task Default -depends Test

task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'

task Publishing -depends Test -action {
    Set-Location $env:BHBuildOutput
    nuget spec $env:BHProjectName

    [xml]$nuspec = Get-Content "$env:BHProjectName.nuspec"
    $nuspec.package.metadata.version = $Version
    $nuspec.Save("$env:BHBuildOutput/$env:BHProjectName.nuspec")

    nuget pack $env:BHProjectName.nuspec
    nuget sources Add -Name "AzureDevOps" -Source "https://pkgs.dev.azure.com/weareinspark/_packaging/$FeedName/nuget/v3/index.json" -username $Username -password $PAT
    nuget push -Source "AzureDevOps" -ApiKey $PAT "$env:BHBuildOutput/InfraStructureAsCode.$Version.nupkg"
}