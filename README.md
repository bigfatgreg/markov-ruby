### Markov Text Generator

A simple ruby based, postgresql backed markov text generator. Don't use this for anything important.

#### Installation

Add this line to your gemfile:

	gem 'markov-ruby'

And then execute:

    $ bundle

Or install it yourself:

    $ gem install markov-ruby

#### Usage

Make a database:

	psql -U DB_USER -c "CREATE DATABASE db_name;"

In an irb session:

	> require 'markov'
	
Import some text:

	> db = Markov::DB.new(dbname: 'db_name')
	> db.import('table_name', 'path/to/text/file.txt')

This may take a while. If the file is large you will want to break it up. 

Generate some text:

	> generator = Markov::Generate.new("db_name", { table: "table_name", length: 20 })
	> generator.text
	
	=> "And comfortably unto Gideon, having two or one, let nothing of water of dogs of Israel, and sorrow of"
	
The bible generates really cool text!

#### TODO:
 
- add shell commands
- make part-of-speech tagging optional on import
- non pg version 