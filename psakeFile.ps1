properties {
    # Set this to $true to create a module with a monolithic PSM1
    $PSBPreference.Build.CompileModule = $false
    $PSBPreference.Help.DefaultLocale = 'en-US'
    $PSBPreference.Test.OutputFile = 'out/testResults.xml'
}

task Default -depends Test

task Test -FromModule PowerShellBuild -minimumVersion '0.6.1'

task Publishing -action {
    Set-Location $env:BHBuildOutput
    nuget spec InfraStructureAsCode

    [xml]$nuspec = Get-Content InfraStructureAsCode.nuspec
    $nuspec.package.metadata.version = $env:NewVersion
    $nuspec.Save("$env:BHBuildOutput/InfraStructureAsCode.nuspec")
    write-output (Get-Content InfraStructureAsCode.nuspec).package.metadata.version

    nuget pack InfraStructureAsCode.nuspec
    nuget sources Add -Name "AzureDevOps" -Source "https://pkgs.dev.azure.com/weareinspark/_packaging/dylantest/nuget/v3/index.json" -username "dylan.prins@inspark.nl" -password "dxaw4lic5hieaqke5lfqomgnqzhdlp36rmswqrvm55x3y22s7d4q"
    nuget push -Source "AzureDevOps" -ApiKey "dxaw4lic5hieaqke5lfqomgnqzhdlp36rmswqrvm55x3y22s7d4q" InfraStructureAsCode.$env:NewVersion.nupkg
}