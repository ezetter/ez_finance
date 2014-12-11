# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

AccountType.create(description: 'Brokerage', retirement: false)
AccountType.create(description: 'Checking', retirement: false)
AccountType.create(description: 'Savings', retirement: false)
AccountType.create(description: 'Money Market', retirement: false)
AccountType.create(description: 'Traditional Ira', retirement: true)
AccountType.create(description: 'Roth Ira', retirement: true)
AccountType.create(description: '401K', retirement: true)