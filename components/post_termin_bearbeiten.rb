post '/termin/:id/bearbeiten' do |tid| #id des Termins
    termin = db.in("Termin").get(tid.to_i) #Datensatz des Termins
    lehrkraft_termin = termin["Lehrkraft"].to_i #Lehrkraft des Termins
    puts lehrkraft_termin
    zeit_alt = termin["Zeitfenster"].to_i
    zeit_neu = params["Zeitfenster"].to_s #09:00
    zeit_id = db.in("Zeitfenster").one_where("Beginn = ?", [zeit_neu])["id"] #id des neues Zeitfensters
    puts zeit_id
    schueler_id = termin["Schueler"]
    alle_termine = db.in("Termin").one_where("Zeitfenster = ? and Lehrkraft = ?", [zeit_id, lehrkraft_termin])
    name = db.in("Schueler").one_where("id = ?", [schueler_id])["Name"] #Name des Schülers 
    # Termin gehört zu angemeldetem Schüler  
    if name == current_user["Name"] && current_user["Kuerzel"] == nil && name != "" then
        # Zeitfenster existiert und ist noch immer frei
        if zeit_id != nil && alle_termine == nil  then #Lehrkraft hat da noch keinen Temrin fehlt
            # existierenden Termin-Datensatz aus Datenbank abfragen --> termin
            # Kommentar im Datensatz mit Eingabe überschreiben
            # Zeitfenster im Datensatz mit Eingabe überschreiben
            # Datensatz in der Datenbank speichern
            db.in("Termin").set(tid,{'Kommentar'=>params["Kommentar"], 'Lehrkraft'=>lehrkraft_termin, 'Schueler'=> schueler_id, 'Zeitfenster'=> zeit_id})
            redirect to "/"
        end
    else
        
    # Weiterleitung GET /
        redirect to "/"
    end
  

end

def lehrkraft_frei_in?(alle_termine) 
    if alle_termine != nil then
        return false
    else
        return true
    end
end






