
require 'bcrypt'
require_relative 'database_sqlite'

db = DB.new 'db/elternsprechtag.sqlite'

db.init('Klasse', '
  id integer primary key autoincrement not null unique,
  Bezeichnung text not null
')

db.init('Lehrkraft', '
  id integer primary key autoincrement not null unique,
  Name text not null,
  Kuerzel text not null unique,
  PwHash text not null,
  istAdmin integer not null
')

db.execute "create index ixLehrkraftKuerzel on Lehrkraft(Kuerzel);"

db.init('Schueler', '
  id integer primary key autoincrement not null unique,
  Name text not null unique,
  PwHash text not null,
  Klasse integer not null references Klasse(id) on delete cascade
')

db.execute "create index ixSchuelerName on Schueler(Name);"
db.execute "create index ixSchuelerKlasse on Schueler(Klasse);"

db.init('unterrichtet', '
  id integer primary key autoincrement not null unique,
  Lehrkraft integer not null references Lehrkraft(id) on delete cascade,
  Klasse integer not null references Klasse(id) on delete cascade
')

db.execute "create index ixUnterrichtetLehrkraft on unterrichtet(Lehrkraft);"
db.execute "create index ixUnterrichtetKlasse on unterrichtet(Klasse);"

db.init('Gespraechswunsch', '
  id integer primary key autoincrement not null unique,
  Lehrkraft integer not null references Lehrkraft(id) on delete cascade,
  Schueler integer not null references Schueler(id) on delete cascade
')

db.execute "create index ixGesprWuLehrkraft on Gespraechswunsch(Lehrkraft);"
db.execute "create index ixGesprWuSchueler on Gespraechswunsch(Schueler);"

db.init('Anfrage', '
  id integer primary key autoincrement not null unique,
  Lehrkraft integer not null references Lehrkraft(id) on delete cascade,
  Schueler integer not null references Schueler(id) on delete cascade
')

db.execute "create index ixAnfrageLehrkraft on Anfrage(Lehrkraft);"
db.execute "create index ixAnfrageSchueler on Anfrage(Schueler);"

db.init('Zeitfenster', '
  id integer primary key autoincrement not null unique,
  Beginn text not null,
  Dauer integer not null
')

db.init('Termin', '
  id integer primary key autoincrement not null unique,
  Kommentar text not null,
  Lehrkraft integer not null references Lehrkraft(id) on delete cascade,
  Schueler integer references Schueler(id) on delete cascade,
  Zeitfenster integer not null references Zeitfenster(id) on delete cascade
')

db.execute "create index ixTerminLehrkraft on Termin(Lehrkraft);"
db.execute "create index ixTerminSchueler on Termin(Schueler);"
db.execute "create index ixTerminZeitfenster on Termin(Zeitfenster);"

db.init('Phase', '
  id integer primary key autoincrement not null unique,
  Beginn text not null,
  Bezeichnung text not null
')

def mkLehrkraft(name, kuerzel, password, istAdmin)
  return { 
    "Name" => name,
    "Kuerzel" => kuerzel,
    "PwHash" => BCrypt::Password.create(password).to_s,
    "istAdmin" => istAdmin
  }
end

# create Admin user
print "Bitte Admin-Passwort eingeben: "
password = gets.chop
db.in("Lehrkraft").insert(mkLehrkraft("Admin", "admin", password, 1))

# create phases
beginn = DateTime.now
["Konfiguration", "PrioBuchung", "Buchung", "Abruf"].each do |phase|
  beginn = beginn.next_day
  db.in('Phase').insert({ "Beginn" => beginn.to_s, "Bezeichnung" => phase })
end

# create test data

lehrkraefte = [
  mkLehrkraft("Albert Einstein", "ae", "einstein", 0),
  mkLehrkraft("Grace Hopper", "gh", "hopper", 1)
]

def mkSchueler(name, password, klasse)
  return {
    "Name" => name,
    "PwHash" => BCrypt::Password.create(password).to_s,
    "Klasse" => klasse
  }
end

schueler = [
  mkSchueler("Max", "max", "2a"),
  mkSchueler("Moritz", "moritz", "2a"),
  mkSchueler("Tick", "tick", "3b"),
  mkSchueler("Trick", "trick", "3b"),
  mkSchueler("Track", "track", "3b")
]

lehrkraefte.each do |lehrkraft|
  db.in("Lehrkraft").insert(lehrkraft)
end

schueler.each do |sch|
  sch["Klasse"] = db.in("Klasse").insert({ "Bezeichnung" => sch["Klasse"] })
  db.in("Schueler").insert(sch)
end

db.in('unterrichtet').insert({ "Lehrkraft" => 2, "Klasse" => 1 })
db.in('unterrichtet').insert({ "Lehrkraft" => 3, "Klasse" => 1 })
db.in('unterrichtet').insert({ "Lehrkraft" => 3, "Klasse" => 2 })

now = DateTime.now
tag = DateTime.new(now.year, now.month, now.day, 9).next_day(10)
18.times do
  db.in("Zeitfenster").insert({
    "Beginn" => tag.to_s,
    "Dauer" => 10
  })
  db.in("Zeitfenster").insert({
    "Beginn" => (tag + Rational(5, 24)).to_s, # 5 hours later
    "Dauer" => 10
  })
  tag = tag + Rational(10, 24*60) # 10 minutes later
end

db.in("Gespraechswunsch").insert({ "Lehrkraft" => 2, "Schueler" => 1 })
db.in("Gespraechswunsch").insert({ "Lehrkraft" => 2, "Schueler" => 2 })
db.in("Anfrage").insert({ "Lehrkraft" => 3, "Schueler" => 2 })
db.in("Termin").insert({
  "Lehrkraft" => 3,
  "Zeitfenster" => 1,
  "Kommentar" => "Pause"
})
db.in("Termin").insert({
  "Lehrkraft" => 2,
  "Schueler" => 1,
  "Zeitfenster" => 2,
  "Kommentar" => "mit beiden Eltern"
})
