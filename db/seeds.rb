# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Unit.create(unit: 'g')
Unit.create(unit: 'kg')
Unit.create(unit: 'tsp')
Unit.create(unit: 'Tbls')
Unit.create(unit: 'oz')
Unit.create(unit: 'lb')
Unit.create(unit: 'floz')
Unit.create(unit: 'c')
Unit.create(unit: 'qt')
Unit.create(unit: 'ml')

User.create!({:username => "admin", :admin => true, :password => "password", :password_confirmation => "password" })
Option.create({randomDate: Date})