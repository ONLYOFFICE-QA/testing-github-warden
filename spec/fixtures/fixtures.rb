# frozen_string_literal: true

require_relative 'fixtures_responce_objects'

# Class for storing fixtures
class Fixtures
  extend FixturesResponceObjects
  ADDRESS = '0.0.0.0'
  PORT = 3000
  SECRET_TOKEN = '12345'
  WRONG_HTTP_X_HUB_SIGNATURE = 'sha1=wrong_key'
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
