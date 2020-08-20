Feature: Include DmUniboCommon::ApplicationPolicy

  Scenario: has record_organization_manager? method
    Given today is "Sunday"
    When I ask whether it's Friday yet
    Then I should be told "Nope"

  Scenario: Friday is Friday
    Given today is "Friday"
    When I ask whether it's Friday yet
    Then I should be told "TGIF"

