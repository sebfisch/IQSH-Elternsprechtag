# Konsistenzprüfung:

# angemeldet als Lehrkraft
# kein Termin mit einem Schueler für angemeldete Lehrkraft mit angegebenem Zeitfenster gespeichert
# Falls konsistent:

# Falls kein Termin existiert: neuen Termin mit übermitteltem Kommentar speichern
# Falls Termin (also Pause) existiert: Kommentar zu vorhandenem Datensatz aktualisieren
# Weiterleitung GET /

post '/zeitfenster/:id/pause' do |time_id|
    comment = params["Kommentar"]
    u_id = current_user["id"]
     #falls vorhanden betreffende Terminzeile speichern
    termin = db.in("Termin").one_where("Lehrkraft = ? and Zeitfenster = ?", [u_id.to_i, time_id.to_i])
    # Status Lehrkraft überprüfen
    if get_status(current_user) =="Lehrkraft" || get_status(current_user) =="Admin" then
        #schauen, ob ein Termin vorhanden ist
        if termin != nil then
            #schauen, ob es eine Pause ist
            if termin["Schueler"]==nil then 
                #es ist eine Pause
                db.in("Termin").set(termin["id"], {'Kommentar' => comment, 'Lehrkraft'=>u_id, 'Schueler'=> nil, 'Zeitfenster'=> time_id})
            end
        else
            #eine neue Pause wird angelegt
            db.in("Termin").insert({'Kommentar' => comment, 'Lehrkraft'=>u_id, 'Schueler'=> nil, 'Zeitfenster'=> time_id})
        end
    end
    redirect to '/'
end

