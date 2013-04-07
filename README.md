axiom-arango-adapter
======================

[![Build Status](https://secure.travis-ci.org/mbj/axiom-arango-adapter.png?branch=master)](http://travis-ci.org/mbj/axiom-arango-adapter)
[![Dependency Status](https://gemnasium.com/mbj/axiom-arango-adapter.png)](https://gemnasium.com/mbj/axiom-arango-adapter)
[![Code Climate](https://codeclimate.com/github/mbj/axiom-arango-adapter.png)](https://codeclimate.com/github/mbj/axiom-arango-adapter)

[ArangoDB](https://www.arangodb.org) adapter for [axiom](https://github.com/dkubb/axiom).

Installation
------------

There is currently no gem release for `axiom-arango-adapter` as well as for some of the dependencies, so please use git sources:

```ruby
gem 'aql',                    :git => 'https://github.com/mbj/aql.git'
gem 'axiom-arango-adapter', :git => 'https://github.com/mbj/axiom-arango-adapter.git'
```

Examples
--------

Setup a gateway and connect it to ArangDB:

```ruby
require 'axiom-arango-adapter'
require 'logger'

# Connect to ArangoDB
database = Ashikawa::Core::Database.new('http://localhost:8529')

# Save some people in the database
collection = database['people']

[
  { :id => 1, :firstname => "Jon", :lastname => "Doe" },
  { :id => 2, :firstname => "Sue", :lastname => "Doe" }
].each do |document|
  collection.create(document)
end

# Some logger to see AQL
logger = Logger.new($stderr, :debug)

# Instantiating adapter
adapter = Axiom::Adapter::Arango::Adapter.new(database, logger)

# Setting up a base relation
header = Axiom::Relation::Header.coerce([[:id, Integer], [:firstname, String], [:lastname, String]])
base   = Axiom::Relation::Base.new(:people, header)

# Creating a gateway
gateway = adapter.gateway(base)

# Use the gateway with the examples from the axiom README, for example:
gateway.restrict { |r| r.firstname.eq("Sue") } # restricts to tuples where firstname is "Sue"
```

You can find more examples in the [axiom README](https://github.com/dkubb/axiom/blob/master/README.md).

Fuzzer
------

Axiom has a fuzzer to assist checking the correctness of the adapter and datastore. To run the fuzzer execute the following:

```
bundle exec spec/fuzzer.rb
```

Make sure you run an ArangoDB instance on localhost at the default port!

Credits
-------

* [Markus Schirp (mbj)](https://github.com/mbj) Author
* [triAGENS](https://github.com/triAGENS) for sponsoring this work!

Contributing
-------------

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with Rakefile or version
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

License
-------

This gem is published under the MIT license. See `LICENSE` file.
