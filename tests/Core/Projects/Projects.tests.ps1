BeforeDiscovery {
  $ModuleName = 'AzureDevOpsPowerShell'
  Get-Module $ModuleName | Remove-Module -Force -ErrorAction Ignore
  $path = Join-Path -Path $PSScriptRoot -ChildPath "..\..\..\$ModuleName\$ModuleName.psm1" | Resolve-Path
  Import-Module -Name $path -Verbose:$false -ErrorAction Stop
}

BeforeAll {
  $collectionUri = "https://dev.azure.com/AzureDevOpsPowerShell"
}

InModuleScope $ModuleName {
  Describe "Projects" {
    Context "New-AzDoProject" {
      BeforeAll {
        $params = @{
          CollectionUri = $collectionUri
          ProjectName   = "ProjectTest"
        }
  
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
