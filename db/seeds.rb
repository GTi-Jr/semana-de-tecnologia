# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development? || Rails.env.test?
  Event.create(name:'Evento-teste1', description:'Esse é o evento teste 1', facilitator:'SET', kind:'mini-curso',limit:20, price:20).schedules.create(start_time:DateTime.new(2016,9,5,10,30), end_time:DateTime.new(2016,9,5,12,30))
  Event.create(name:'Evento-teste11', description:'Esse é o evento teste 11', facilitator:'SET', kind:'mini-curso',limit:20, price:20).schedules.create(start_time:DateTime.new(2016,9,5,10,30), end_time:DateTime.new(2016,9,5,13,30))
  Event.create(name:'Evento-teste2', description:'Esse é o evento teste 2', facilitator:'SET', kind:'mini-curso',limit:20, price:20).schedules.create(start_time:DateTime.new(2016,9,7,10,30), end_time:DateTime.new(2016,9,7,12,30))
  Event.create(name:'Evento-teste3', description:'Esse é o evento teste 3', facilitator:'SET', kind:'palestra',limit:20, price:45).schedules.create(start_time:DateTime.new(2016,9,5,14,30), end_time:DateTime.new(2016,9,5,16,30))
  Event.create(name:'Evento-teste4', description:'Esse é o evento teste 4', facilitator:'SET', kind:'palestra',limit:20, price:45).schedules.create(start_time:DateTime.new(2016,9,7,14,30), end_time:DateTime.new(2016,9,7,16,30))
  Event.create(name:'Evento-teste5', description:'Esse é o evento teste 5', facilitator:'SET', kind:'mini-curso',limit:20, price:20).schedules.create(start_time:DateTime.new(2016,9,8,10,30), end_time:DateTime.new(2016,9,8,12,30))
  Event.create(name:'Evento-teste6', description:'Esse é o evento teste 6', facilitator:'SET', kind:'palestra',limit:20, price:45).schedules.create(start_time:DateTime.new(2016,9,8,14,30), end_time:DateTime.new(2016,9,8,16,30))
  Event.create(name:'Evento-teste7', description:'Esse é o evento teste 7', facilitator:'SET', kind:'visita',limit:20, price:35).schedules.create(start_time:DateTime.new(2016,9,6,10,30), end_time:DateTime.new(2016,9,6,12,30))
  Event.create(name:'Evento-teste8', description:'Esse é o evento teste 8', facilitator:'SET', kind:'visita',limit:20, price:35).schedules.create(start_time:DateTime.new(2016,9,6,14,30), end_time:DateTime.new(2016,9,6,16,30))


  Package.create(title:'Ouro', description:'esse é o pacote ouro', limit:20, price:50, courses:4, lectures:3, visits:2)
  Package.create(title:'Prata', description:'esse é o pacote prata', limit:20, price:40, courses:3, lectures:2, visits:1)
  Package.create(title:'Bronze', description:'esse é o pacote bronze', limit:20, price:30, courses:2, lectures:1, visits:0)

  @user = User.create(name: 'Rodrigo', email: 'rodrigo_tn@live.com', semester: 8, course: 'ENG COMP', university: 'UFC', birthday: '07-12-1994', password: '123456as')
  @user.confirm
end

Admin.create(email: 'admin@semanas.com', password: 'admin123')
#30.times do
 # FactoryGirl.create :event
#end