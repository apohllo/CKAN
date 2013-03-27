module CKAN
 class << self
    CKAN.api_base = "http://data.gv.at/katalog/api/"
    attr_accessor :api_base
  end
end

require 'open-uri'
require "net/http"
require "uri"
require 'json'
require_relative 'ckan/model'
require_relative 'ckan/group'
require_relative 'ckan/package'
require_relative 'ckan/resource'
require_relative 'ckan/version'
require_relative 'ckan/datastore'
