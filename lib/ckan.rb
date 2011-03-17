module CKAN
  API_BASE = "http://ckan.net/api/1/"
end

require 'open-uri'
require 'json'
require 'ckan/model'
require 'ckan/group'
require 'ckan/package'
require 'ckan/resource'
require 'ckan/version'
