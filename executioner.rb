# frozen_string_literal: true

# Is a service for commenting and closing bugs from bugzilla
require_relative 'lib/testing-github-warden/executioner'

executioner = Executioner.new
executioner.diagnostic
executioner.main_loop
