#Konsistenzprüfung:
#Name nicht der leere String und nicht mit anderer id verwendet
#Klasse nicht der leere String
#Falls inkonsistent: Weiterleitung GET /schueler/:id/bearbeiten

#Sonst:

#Datensatz zu id aus Datenbank abfragen
#Name mit Eingabe überschreiben
#Wenn Passwort nicht leer, Hash berechnen und im Datensatz eintragen
#Id zu eingegebener Klasse bestimmen (ggf. neu eintragen)
#Id der Klasse im Datensatz eintragen
#Schueler-Datensatz in der Datenbank aktualisieren
#Weiterleitung GET /schueler

post "/schueler/:id/bearbeiten" do  |sid|
    user = current_user 
    schueler = {
        'Name' => params['Name'],
        'Klasse' => params['Klasse'],
        'Passwort' => params['Passwort']
      }
    #if (schueler["Klasse"]==nil || schueler["Name"]!=user["Name"] || schueler["Name"].size<0 ) # Konsistenzprüfung
    #    redirect to "/schueler/:"+sid+"/bearbeiten"
    #end

    #if (get_status(current_user)=="Admin") # wenn Admin arbeiten darf
    #    
    #end
    
    redirect to "/schueler"
    
end