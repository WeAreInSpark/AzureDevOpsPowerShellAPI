BeforeDiscovery {
  $ModuleName = 'AzureDevOpsPowerShell'
  Get-Module $ModuleName | Remove-Module -Force -ErrorAction Ignore
  $path = Join-Path -Path $PSScriptRoot -ChildPath "..\..\..\$ModuleName\$ModuleName.psm1" | Resolve-Path
  Import-Module -Name $path -Verbose:$false -ErrorAction Stop
}


InModuleScope $ModuleName {
  BeforeAll {
    $collectionUri = "https://dev.azure.com/AzureDevOpsPowerShell"

    $params = @{
      CollectionUri = $collectionUri
      ProjectName   = "ProjectTest"
    }
  }
  Describe "Get-AzDoProject" -Tag Local {
    BeforeAll {
      Mock Invoke-AzDoRestMethod {
        @{
          value = @(
            [PSCustomObject]@{
              CollectionURI     = $CollectionUri
              name              = "ProjectTest"
              ProjectID         = $_.id
              ProjectURL        = $_.url
              ProjectVisibility = $_.visibility
              State             = $_.state
            },
            [PSCustomObject]@{
              CollectionURI     = $CollectionUri
              name              = "ProjectTest2"
              ProjectID         = $_.id
              ProjectURL        = $_.url
              ProjectVisibility = $_.visibility
              State             = $_.state
            }
          )
        }
      }
    }
    It "It provides users with feedback via ShouldProcess when using WhatIf" {
      Get-AzDoProject @params -WhatIf -Verbose 4>&1 | Should -BeLike "Calling Invoke-AzDoRestMethod with {*"
    }

    It "It provides Developers with DebugInfo" {
      (Get-AzDoProject @params -Debug 5>&1 -Confirm:$false )[0] | Should -BeLike "Calling Invoke-AzDoRestMethod with"
    }

    It "Outputs all projects when no value to ProjectName was provided" {
      (Get-AzDoProject -CollectionUri $collectionUri).Count | Should -BeGreaterThan 1
    }

    It "Outputs just the matching ProjectName when a single value was supplied" {
      (Get-AzDoProject @params).Count | Should -Be 1
    }

    It "Outputs just the matching ProjectName when an array was supplied" {
      (Get-AzDoProject -CollectionUri $collectionUri -ProjectName "ProjectTest", "NonExistantProject").Count | Should -Be 1
    }
  }
  Describe "E2E Projects" -Tag E2E {
    Context "New-AzDoProject" {
      BeforeAll {
        $project = New-AzDoProject @params -Confirm:$false
      }

      It "Creates a new project" {
        $project.ProjectName | Should -Be "ProjectTest"
      }

      It "Creates a new project with the correct visibility" {
        $project.ProjectVisibility | Should -Be "private"
      }

      It "Creates a new project with the correct state" {
        $project.State | Should -Be "wellFormed"
      }
    }

    Context "Get-AzDoProject" {
      BeforeAll {
        $params = @{
          CollectionUri = $collectionUri
          ProjectName   = "ProjectTest"
        }

        $project = Get-AzDoProject @params
      }

      It "Gets the correct project" {
        $project.ProjectName | Should -Be "ProjectTest"
      }

      It "Gets the correct project with the correct visibility" {
        $project.ProjectVisibility | Should -Be "private"
      }

      It "Gets the correct project with the correct state" {
        $project.State | Should -Be "wellFormed"
      }
    }

    Context "Remove-AzDoProject" {
      BeforeAll {
        $params = @{
          CollectionUri = $collectionUri
          ProjectName   = "ProjectTest"
        }

        $project = Remove-AzDoProject @params -Confirm:$false
      }

      It "Removes the correct project" {
        $project.id | Should -Not -Be $null
        $project.status | Should -Not -Be $null
        $project.url | Should -Not -Be $null
      }
    }
  }
}
