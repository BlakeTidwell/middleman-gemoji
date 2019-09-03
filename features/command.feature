Feature: gemoji command

  Scenario: Copy emoji files to images_dir
    Given a fixture app "command-app"
    When I run `middleman gemoji`
    Then the exit status should be 0
    And I cd to "source/images/emoji"
    And the following files should exist:
      | basecamp.png |
      | basecampy.png |
      | bowtie.png |
      | feelsgood.png |
      | finnadie.png |
      | goberserk.png |
      | godmode.png |
      | hurtrealbad.png |
      | neckbeard.png   |
      | octocat.png     |
      | rage1.png       |
      | rage2.png       |
      | rage3.png       |
      | rage4.png       |
      | shipit.png      |
      | suspect.png     |
      | trollface.png   |

  Scenario: Copy emoji files with option
    Given a fixture app "command-app"
    When I run `middleman gemoji -p img/gemoji`
    Then the exit status should be 0
    And I cd to "source/img/gemoji"
    And the following files should exist:
      | basecamp.png |
      | basecampy.png |
      | bowtie.png |
      | feelsgood.png |
      | finnadie.png |
      | goberserk.png |
      | godmode.png |
      | hurtrealbad.png |
      | neckbeard.png   |
      | octocat.png     |
      | rage1.png       |
      | rage2.png       |
      | rage3.png       |
      | rage4.png       |
      | shipit.png      |
      | suspect.png     |
      | trollface.png   |
