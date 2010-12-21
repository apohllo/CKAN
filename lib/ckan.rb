module CKAN
  API_BASE = "http://ckan.net/api/2/"
end

require 'open-uri'
require 'json'
require 'ckan/model'
require 'ckan/package'
require 'ckan/resource'
require 'ckan/version'
