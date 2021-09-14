# frozen_string_literal: true

require 'bundler/setup'
require 'sinatra'
require 'json'
require 'yaml'
require 'logger'
require 'redis'
require 'sinatra/base'
require 'sinatra/custom_logger'
require_relative 'helpers/allowed_branches_parser'
require_relative 'helpers/hook_direction'
require_relative 'helpers/github_responce_object'
