= CKAN

* http://github.com/apohllo/CKAN

= DESCRIPTION

'CKAN' is a Ruby client of the Comprehensive Knowledge Archive Network.

= FEATURES/PROBLEMS

* The project is in pre-alpha state.
* CKAN packages REST API wrapper.
* CKAN resources class.
* Query API for CKAN packages.

= SYNOPSIS

'CKAN' is a Ruby client for the Comprehensive Knowledge Archive Network. It
provides an object oriented interface for the repository based on the REST API
of CKAN.

= INSTALL

The gem is available at rubygems.org, so you can install it with:

  $ gem install ckan

= BASIC USAGE

  require 'ckan'

  # get all CKAN packages
  packages = CKAN::Package.find

  # query for CKAN packages
  packages = CKAN::Package.find(:tags => ["lod", "government"], :groups => "lodcloud")

  # get the name of the package (this is a lazy call to the REST API)
  packages.first.name

  # get the resources of the package
  packages.first.resources

  # query for CKAN groups
  groups = CKAN::Group.find

  # get the description of a group
  groups.first.description

  # get the list of packages inside a group
  groups.first.packages

== LICENSE:
 
(The MIT License)

Copyright (c) 2010 Aleksander Pohl

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

== FEEDBACK

* mailto:apohllo@o2.pl

