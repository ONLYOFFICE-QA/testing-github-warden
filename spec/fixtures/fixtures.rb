# frozen_string_literal: true

require 'json'

# Class for storing fixtures
class Fixtures
  def self.commit
    file = File.read(File.join(File.dirname(__FILE__), './fixtures_responce_objects/commit.json'))
    JSON.parse(file)
  end

  def self.ping
    file = File.read(File.join(File.dirname(__FILE__), './fixtures_responce_objects/ping.json'))
    JSON.parse(file)
  end

  def self.repo_match_commit
    file = File.read(File.join(File.dirname(__FILE__), './fixtures_responce_objects/repo_match_commit.json'))
    JSON.parse(file)
  end

  BUG_ID_TEST = '39463'

  CHANGE_STATUS_AND_COMMENT = ["[se] Fix bug #{BUG_ID_TEST}",
                               "[charts] Fix bug #{BUG_ID_TEST}",
                               "Fix bug ##{BUG_ID_TEST}",
                               "Fixed bug ##{BUG_ID_TEST}",
                               "[x2t] Fix bug #{BUG_ID_TEST}",
                               "[x2t] Fix  bug #{BUG_ID_TEST}",
                               "[x2t] Fix bug  #{BUG_ID_TEST}",
                               "[x2t] Fix  bug  #{BUG_ID_TEST}",
                               "[x2t]  Fix  bug  #{BUG_ID_TEST} ",
                               "[x2t] Fix Bug #{BUG_ID_TEST}",
                               "[x2t] fIx bUg #{BUG_ID_TEST}"].freeze
  COMMENT_ONLY = ["[se] Bug #{BUG_ID_TEST}",
                  "[se] R1C1 for bug #{BUG_ID_TEST}",
                  "[se] For bug #{BUG_ID_TEST} (sort first row)",
                  "[x2t] For bug #{BUG_ID_TEST}",
                  "[x2t] For  bug #{BUG_ID_TEST}",
                  "[x2t] For BUG #{BUG_ID_TEST}",
                  "[x2t] For BUG  #{BUG_ID_TEST}",
                  "[x2t]  For  BUG  #{BUG_ID_TEST} ",
                  "[x2t] For Bug #{BUG_ID_TEST}",
                  "[se] For bug #{BUG_ID_TEST}
                    Fix calculate gradient without distance"].freeze

  DO_NOTHING = ['Fix bug with recalculating', 'bug with recalculating', 'Fix with recalculating'].freeze
end
