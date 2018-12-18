require_relative '../../spec/data/abstract_request'
class StaticData
  extend AbstractRequest
  ADDRESS = '0.0.0.0'.freeze
  PORT = 3000
  MAINPAGE = "http://#{ADDRESS}:#{PORT}".freeze
  SECRET_TOKEN = '12345'.freeze
  WRONG_HTTP_X_HUB_SIGNATURE = 'sha1=wrong_key'.freeze
  BUG_ID_TEST = '39463'.freeze

  CHANGE_STATUS_AND_COMMENT = ["[se] Fix bug #{BUG_ID_TEST}",
                               "[charts] Fix bug #{BUG_ID_TEST}",
                               "Fix bug ##{BUG_ID_TEST}"].freeze
  COMMENT_ONLY = ["[se] Bug #{BUG_ID_TEST}",
                  "[se] R1C1 for bug #{BUG_ID_TEST}",
                  "[se] For bug #{BUG_ID_TEST} (sort first row)"].freeze

  DO_NOTHING = ['Fix bug with recalculating', 'bug with recalculating', 'Fix with recalculating'].freeze
end
