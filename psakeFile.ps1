Properties {
    $PSBPreference.Help.DefaultLocale = 'en-US'
<<<<<<< HEAD
    $PSBPreference.Test.OutputFile = 'Output/testResults.xml'
    $PSBPreference.Test.ScriptAnalysis.SettingsPath = 'tests/ScriptAnalyzerSettings.psd1'
=======
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
>>>>>>> 18d4dd8 (InitialVersion)
    $PSBPreference.Publish.PSRepository = $PSRepository
    $PSBPreference.Publish.PSRepositoryApiKey = $PSRepositoryApiKey
    $PSBPreference.Test.ScriptAnalysis.Enabled = $ScriptAnalysisEnabled
    $PSBPreference.Test.CodeCoverage.Enabled = $CodeCoverageEnabled
    $PSBPreference.Test.Enabled = $TestEnabled
}

Task Default -depends Test

Task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Publish -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Init -FromModule PowerShellBuild -minimumVersion '0.6.1'

Task Clean -FromModule PowerShellBuild -minimumVersion '0.6.1'

<<<<<<< HEAD
Task Stagefiles -FromModule PowerShellBuild -minimumVersion '0.6.1'
=======
Task Stagefiles -FromModule PowerShellBuild -minimumVersion '0.6.1'
>>>>>>> 18d4dd8 (InitialVersion)
