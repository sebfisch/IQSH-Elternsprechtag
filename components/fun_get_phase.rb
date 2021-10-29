def get_phase
    konfiguration = DateTime.parse(db.in("Phase").get(1)["Beginn"])
    prioBuchung = DateTime.parse(db.in("Phase").get(2)["Beginn"])
    buchung = DateTime.parse(db.in("Phase").get(3)["Beginn"])
    abruf = DateTime.parse(db.in("Phase").get(4)["Beginn"])
   if DateTime.now > abruf then 
        return "Abruf"
   elsif DateTime.now > buchung then 
        return "Buchung"
   elsif DateTime.now > prioBuchung then 
        return "PrioBuchung"
   elsif DateTime.now > konfiguration then 
        return "Konfiguration"
   else 
        return "Einrichtung"
   end
end
