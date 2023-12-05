BeforeDiscovery {
  $ModuleName = 'AzureDevOpsPowerShell'
  Get-Module $ModuleName | Remove-Module -Force -ErrorAction Ignore
  $path = Join-Path -Path $PSScriptRoot -ChildPath "..\..\..\..\$ModuleName\$ModuleName.psm1" | Resolve-Path
  Import-Module -Name $path -Verbose:$false -ErrorAction Stop
}


InModuleScope $ModuleName {
  BeforeAll {
    $collectionUri = "https://dev.azure.com/AzureDevOpsPowerShell"

    $params = @{
      CollectionUri = $collectionUri
      ProjectName   = "ProjectTest"
      Confirm       = $false
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
              State             = "wellFormed"
            },
            [PSCustomObject]@{
              CollectionURI     = $CollectionUri
              name              = "ProjectTest2"
              ProjectID         = $_.id
              ProjectURL        = $_.url
              ProjectVisibility = $_.visibility
              State             = "wellFormed"
            }
          )
        }
      }
    }

    It "It provides users with feedback via ShouldProcess when using WhatIf" {
      Get-AzDoProject @params -WhatIf -Verbose 4>&1 | Should -BeLike "Calling Invoke-AzDoRestMethod with {*"
    }

    It "It provides Developers with DebugInfo" {
      (Get-AzDoProject @params -Debug -Confirm:$false 5>&1 )[0] | Should -BeLike "Calling Invoke-AzDoRestMethod with"
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

    It "Doesn't output when no matching ProjectName was supplied" {
      (Get-AzDoProject -CollectionUri $collectionUri -ProjectName "NonExistantProject", "NonExistantProject2") | Should -BeNullOrEmpty
    }
  }

  Describe "New-AzDoProject" -Tag Local {

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
              State             = "wellFormed"
            },
            [PSCustomObject]@{
              CollectionURI     = $CollectionUri
              name              = "ProjectTest2"
              ProjectID         = $_.id
              ProjectURL        = $_.url
              ProjectVisibility = $_.visibility
              State             = "wellFormed"
            }
          )
        }
      }
    }

    It "It provides users with feedback via ShouldProcess when using WhatIf" {
      New-AzDoProject @params -WhatIf -Verbose 4>&1 | Should -BeLike "Calling Invoke-AzDoRestMethod with {*"
    }

    # It "It provides Developers with DebugInfo" {
    #   (New-AzDoProject @params -Debug -Confirm:$false 5>&1 )[0] | Should -BeLike "Calling Invoke-AzDoRestMethod with"
    # }

    It "Outputs just the matching ProjectName when a single value was supplied" {
      (New-AzDoProject @params).Count | Should -Be 1
    }

    # It "Outputs just the matching ProjectName when an array was supplied" {
    #   (New-AzDoProject -CollectionUri $collectionUri -ProjectName "ProjectTest", "NonExistantProject" -Confirm:$false).Count | Should -Be 1
    # }

    # It "Doesn't output when no matching ProjectName was supplied" {
    #   (New-AzDoProject -CollectionUri $collectionUri -ProjectName "NonExistantProject", "NonExistantProject2" -Confirm:$false) | Should -BeNullOrEmpty
    # }
  }
}

# Describe "Remove-AzDoProject" -Tag Local {

#   BeforeAll {
#     Mock Invoke-AzDoRestMethod {
#       @{
#         value = @(
#           [PSCustomObject]@{
#             CollectionURI     = $CollectionUri
#             name              = "ProjectTest"
#             ProjectID         = $_.id
#             ProjectURL        = $_.url
#             ProjectVisibility = $_.visibility
#             State             = "wellFormed"
#           },
#           [PSCustomObject]@{
#             CollectionURI     = $CollectionUri
#             name              = "ProjectTest2"
#             ProjectID         = $_.id
#             ProjectURL        = $_.url
#             ProjectVisibility = $_.visibility
#             State             = "wellFormed"
#           }
#         )
#       }
#     }
#   }

#   It "It provides users with feedback via ShouldProcess when using WhatIf" {
#     Remove-AzDoProject @params -WhatIf -Verbose 4>&1 | Should -BeLike "Calling Invoke-AzDoRestMethod with {*"
#   }

#   It "It provides Developers with DebugInfo" {
#     (Remove-AzDoProject @params -Debug -Confirm:$false 5>&1 )[0] | Should -BeLike "Calling Invoke-AzDoRestMethod with"
#   }

#   It "Outputs all projects when no value to ProjectName was provided" {
#     (Remove-AzDoProject -CollectionUri $collectionUri).Count | Should -BeGreaterThan 1
#   }

#   It "Outputs just the matching ProjectName when a single value was supplied" {
#     (Remove-AzDoProject @params).Count | Should -Be 1
#   }

#   It "Outputs just the matching ProjectName when an array was supplied" {
#     (Remove-AzDoProject -CollectionUri $collectionUri -ProjectName "ProjectTest", "NonExistantProject").Count | Should -Be 1
#   }

#   It "Doesn't output when no matching ProjectName was supplied" {
#     (Remove-AzDoProject -CollectionUri $collectionUri -ProjectName "NonExistantProject", "NonExistantProject2") | Should -BeNullOrEmpty
#   }
# }
