BeforeDiscovery {
  $ModuleName = 'AzureDevOpsPowerShell'
  Get-Module $ModuleName | Remove-Module -Force -ErrorAction Ignore
  $path = Join-Path -Path $PSScriptRoot -ChildPath "..\..\..\..\$ModuleName\$ModuleName.psm1" | Resolve-Path
  Import-Module -Name $path -Verbose:$false -ErrorAction Stop
}


InModuleScope $ModuleName {
  BeforeAll {
    $collectionUri = "https://dev.azure.com/AzureDevOpsPowerShell"

  }

  Describe "Get-AzDoVariableGroup" -Tag Local {

    BeforeAll {
      Mock Invoke-AzDoRestMethod {
        @{
          value = @(
            [PSCustomObject]@{
              CollectionURI = $CollectionUri
              ProjectName   = "ProjectTest"
              Name          = "VariableGroup1"
              Id            = $_.id
              Variables     = $_.variables
              CreatedOn     = $_.createdOn
              IsShared      = $_.isShared
            },
            [PSCustomObject]@{
              CollectionURI = $CollectionUri
              ProjectName   = "ProjectTest"
              Name          = "VariableGroup2"
              Id            = $_.id
              Variables     = $_.variables
              CreatedOn     = $_.createdOn
              IsShared      = $_.isShared
            }
          )
        }
      }
    }

    It "It provides users with feedback via ShouldProcess when using WhatIf" {
      Get-AzDoVariableGroup -CollectionUri $collectionUri -ProjectName "ProjectTest" -WhatIf -Verbose 4>&1 | Out-String | Should -BeLike "*Calling Invoke-AzDoRestMethod with {*"
    }

    # It "Outputs all projects when no value to ProjectName was provided" {
    #   (Get-AzDoVariableGroup -CollectionUri $collectionUri -ProjectName "ProjectTest").Count | Should -Be 2
    # }

    # It "Outputs just the matching ProjectName when a single value was supplied" {
    #   (Get-AzDoVariableGroup -CollectionUri $collectionUri -ProjectName "ProjectTest" -VariableGroupName "VariableGroup1").Count | Should -Be 1
    # }

    # It "Outputs just the matching ProjectName when an array was supplied" {
    #   (Get-AzDoVariableGroup -CollectionUri $collectionUri -ProjectName "ProjectTest" -VariableGroupName "VariableGroup1", "VariableGroup1").Count | Should -Be 2
    # }

    # It "Outputs just the matching ProjectName when the pipeline is used" {
    #   ("VariableGroup1", "VariableGroup1" | Get-AzDoVariableGroup -CollectionUri $collectionUri -ProjectName "ProjectTest").Count | Should -Be 2
    # }

    It "Doesn't output when no matching ProjectName was supplied" {
      (Get-AzDoVariableGroup -CollectionUri $collectionUri -ProjectName "ProjectTest" -VariableGroupName "NonExisting", "NonExisting2" ) | Should -BeNullOrEmpty
    }
  }
}
