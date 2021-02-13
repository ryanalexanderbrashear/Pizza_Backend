#!/usr/bin/ruby

require 'pg'

begin

    con = PG.connect :dbname => 'pizza'
    puts con.server_version

rescue PG::Error => e

    puts e.message 
    
ensure

    con.close if con
    
end