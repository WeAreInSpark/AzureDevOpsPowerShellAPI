Properties {
    $PSBPreference.Help.DefaultLocale = 'en-US'
<<<<<<< HEAD
    $PSBPreference.Test.OutputFile = 'Output/testResults.xml'
    $PSBPreference.Test.ScriptAnalysis.SettingsPath = 'tests/ScriptAnalyzerSettings.psd1'
=======
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
<<<<<<< HEAD
>>>>>>> 18d4dd8 (InitialVersion)
=======
>>>>>>> 18d4dd8 (InitialVersion)
    $PSBPreference.Publish.PSRepository = $PSRepository
    $PSBPreference.Publish.PSRepositoryApiKey = $PSRepositoryApiKey
    $PSBPreference.Test.ScriptAnalysis.Enabled = $ScriptAnalysisEnabled
    $PSBPreference.Test.CodeCoverage.Enabled = $CodeCoverageEnabled
    $PSBPreference.Test.Enabled = $TestEnabled
}

Task Default -depends Test

<<<<<<< HEAD
<<<<<<< HEAD
Task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Publish -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Init -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Clean -FromModule PowerShellBuild -minimumVersion '0.6.1'

<<<<<<< HEAD
Task Stagefiles -FromModule PowerShellBuild -minimumVersion '0.6.1'
=======
Task Stagefiles -FromModule PowerShellBuild -minimumVersion '0.6.1'
>>>>>>> 18d4dd8 (InitialVersion)
=======
task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'
=======
Task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'
>>>>>>> 18d4dd8 (InitialVersion)

Task Publish -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Init -FromModule PowerShellBuild -minimumVersion '0.6.1'

<<<<<<< HEAD
    nuget pack InfraStructureAsCode.nuspec
    nuget sources Add -Name "AzureDevOps" -Source "https://pkgs.dev.azure.com/weareinspark/_packaging/dylantest/nuget/v3/index.json" -username "dylan.prins@inspark.nl" -password "dxaw4lic5hieaqke5lfqomgnqzhdlp36rmswqrvm55x3y22s7d4q"
    if (Test-Path -Path "$env:BHBuildOutput/InfraStructureAsCode.$env:Version.nupkg") {
        nuget push -Source "AzureDevOps" -ApiKey "dxaw4lic5hieaqke5lfqomgnqzhdlp36rmswqrvm55x3y22s7d4q" InfraStructureAsCode.$env:Version.nupkg
    }
    else {
        Write-Output "::error file=psakeFile.ps1,line=23,col=5,endColumn=85::.nupkg file does noe exist"
    }
}
>>>>>>> 690e7a4 (Working version)
=======
Task Clean -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Stagefiles -FromModule PowerShellBuild -minimumVersion '0.6.1'
>>>>>>> 18d4dd8 (InitialVersion)
