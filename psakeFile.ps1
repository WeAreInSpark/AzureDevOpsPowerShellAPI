Properties {
    $PSBPreference.Help.DefaultLocale = 'en-US'
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
    $PSBPreference.Test.ScriptAnalysis.SettingsPath = "tests/ScriptAnalyzerSettings.psd1"
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

Task Stagefiles -FromModule PowerShellBuild -minimumVersion '0.6.1'