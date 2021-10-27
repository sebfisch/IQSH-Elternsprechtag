require_relative 'database_sqlite'

db = DB.new 'db/elternsprechtag.sqlite'

db.init('Klasse', '
  id integer primary key autoincrement not null unique,
  Bezeichnung text not null
')

db.init('Lehrkraft', '
  id integer primary key autoincrement not null unique,
  Name text not null,
  Kuerzel text not null,
  PwHash text not null,
  istAdmin integer not null
')

db.init('Schueler', '
  id integer primary key autoincrement not null unique,
  Name text not null,
  PwHash text not null,
  Klasse integer not null references Klasse(id) on delete cascade
')

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

