# Erwartet einen kompletten user-Datensatz
def get_status(usr)
 
    if db.in("Schueler").id_of(usr) != nil then
        return 'Schueler'
    elsif db.in("Lehrkraft").id_of(usr) != nil then
      if usr["istAdmin"] == 1 then 
        return 'Admin'
      else
        return 'Lehrkraft'
      end
    end
  end
  