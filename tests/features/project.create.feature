@api
Feature: Create a project
  In order to start developing a drupal site
  As a project admin
  I need to create a new project

  Scenario: Create a new drupal 8 project

    Given users:
      | name       | status | roles          |
      | testadminuser | 1      | administrator |

    Given I am logged in as "testadminuser"
    And I am on the homepage
    When I click "Projects"
    And I click "Start a new Project"
    Then I should see "Step 1"
    Then I fill in "projectname" for "Project Code Name"
    And I fill in "http://github.com/opendevshop/drupal" for "Git URL"
    When I press "Next"

    # Step 2
    Then print current URL
#    Then save last response
    Then I should see "projectname"
    And I should see "http://github.com/opendevshop/drupal"
#   Uncomment once we have steps to unset the path to drupal.
#    When I fill in "docroot" for "Path to Drupal"

    # Step 3
    When I press "Next"
    Then I should see "Please wait while we connect to your repository and determine any branches."
#    And I should see "Path to Drupal: docroot"

    When I run drush "hosting-tasks -v"
    Then print last drush output
    And I wait "10" seconds
    And I reload the page

#    Then save last response
    Then I should see "Create as many new environments as you would like."
    When I fill in "dev" for "project[environments][NEW][name]"
    And I select "7.x-releases" from "project[environments][NEW][git_ref]"

#    And I press "Add environment"
#    And I fill in "live" for "project[environments][NEW][name]"
#    And I select "7.41" from "project[environments][NEW][git_ref]"
#    And I press "Add environment"
    Then I press "Next"
#    Then print last response

    # Step 4
    And I should see "dev"
#    And I should see "live"
#    And I should see "7.41"
    And I should see "7.x-releases"

    When I run drush "hosting-tasks -v"
    Then print last drush output
    And I wait "10" seconds
    And I reload the page

    Then I should see "dev"
    And I should see "test"
#    And I should see "7.41"

    And I should see "7.x-releases"
    And I wait "10" seconds
    And I reload the page
    When I select "minimal" from "install_profile"
    And I press "Finish"

    # FINISH!
    Then I should see "Your project has been created. Your sites are being installed."
    And I should see "Dashboard"
    And I should see "Settings"
    And I should see "Logs"
    And I should see "Minimal"
#    And I should see "http://github.com/opendevshop/drupal"
    And I should see the link "dev"
#    And I should see the link "live"

    When I run drush "hosting-tasks -v"
    Then print last drush output
    Then drush output should not contain "This task is already running, use --force"

    Then I wait "5" seconds
    And I reload the page
    Given I go to "http://dev.projectname.devshop.travis"
#    When I click "Visit Environment"
    Then I should see "No front page content has been created yet."
