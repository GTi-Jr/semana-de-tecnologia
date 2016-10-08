# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development? || Rails.env.test?
  package1 = Package.create(title:'Ouro', description:'Este é o pacote ouro', price:50, limit:50)
  package2 = Package.create(title:'Prata', description:'Este é o pacote prata', price:40, limit:50)
  package3 = Package.create(title:'Bronze', description:'Este é o pacote bronze', price:30, limit:50)

  event_type1 = EventType.create(name: 'Palestra')
  event_type2 = EventType.create(name: 'Visita')
  event_type3 = EventType.create(name: 'Minicurso')

  PackageEventType.create event_type_id: event_type1.id, package_id: package1.id, limit: 3
  PackageEventType.create event_type_id: event_type2.id, package_id: package1.id, limit: 2
  PackageEventType.create event_type_id: event_type3.id, package_id: package1.id, limit: 2


  Event.create(name:'Evento-teste1', description:'Esse é o evento teste 1', facilitator:'SET', limit:20, price:20, event_type_id:1).schedules.create(start_time:DateTime.new(2016,9,5,10,30), end_time:DateTime.new(2016,9,5,12,30))
  Event.create(name:'Evento-teste2', description:'Esse é o evento teste 2', facilitator:'SET', limit:20, price:20, event_type_id:2).schedules.create(start_time:DateTime.new(2016,9,5,10,30), end_time:DateTime.new(2016,9,5,13,30))
  Event.create(name:'Evento-teste3', description:'Esse é o evento teste 3', facilitator:'SET', limit:20, price:20, event_type_id:3).schedules.create(start_time:DateTime.new(2016,9,5,10,30), end_time:DateTime.new(2016,9,5,12,30))
  Event.create(name:'Evento-teste4', description:'Esse é o evento teste 4', facilitator:'SET', limit:20, price:20, event_type_id:1).schedules.create(start_time:DateTime.new(2016,9,5,10,30), end_time:DateTime.new(2016,9,5,12,30))

  @user = User.create(name: 'Rodrigo', email: 'rodrigo_tn@live.com', semester: 8, course: 'ENG COMP', university: 'UFC', birthday: '07-12-1994', password: '123456as')
  @user.confirm
end

Admin.create(email: 'admin@semanas.com', password: Rails.application.secrets.admin_password? ? Rails.application.secrets.admin_password? : 'admin123')