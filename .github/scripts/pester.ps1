$config = New-PesterConfiguration
$config.Run.Path = @('./tests/')
$config.Run.ExcludePath = @('./tests/Indented.ScriptAnalyzerRules/')
$config.Run.Exit = $true
$config.Output.CIFormat = 'GithubActions'
$config.Output.Verbosity = 'Detailed'
Invoke-Pester -Configuration $config

# './tests/pester.ps1',
