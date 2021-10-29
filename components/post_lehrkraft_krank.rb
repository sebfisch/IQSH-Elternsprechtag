#Konsistenzprüfung:
#
#    als Lehrkraft angemeldet
#    istAdmin oder id gehört zu angemeldeter Lehrkraft
#
#Falls konsistent:
#
#    alle Termine (und Pausen) der Lehrkraft mit id löschen und entsprechende Anfragen speichern
#    Gesprächswünsche der Lehrkraft mit id löschen
#    Pausen für alle Zeitfenster eintragen (Kommentar: "krank")
#

#Weiterleitung GET /


post '/lehrkraft/:id/krank' do |lid|
#    puts get_status(current_user)
#    puts current_user['id']
#    puts lid
#    puts get_status(current_user) == 'Lehrkraft' && current_user['id'].to_i == lid.to_i
    if (get_status(current_user) == 'Lehrkraft' && current_user['id'].to_i == lid.to_i) || get_status(current_user) == 'Admin' then
        arr = db.in('Termin').all_where('Lehrkraft = ?', [lid])
        # Für alle Termine Gesprächsanfrage erstellen
        arr.each do |termin|
            schueler = termin['Schueler']
            if schueler != nil then
                db.in("Anfrage").insert({"Lehrkraft" => lid.to_i, "Schueler" => schueler.to_i})
            end
            # Alle Termine der LK löschen
            db.in('Termin').delete(termin['id'])
        end
        # Alle Zeitfenster der LK als Pause blocken.
        zeitfenster = db.in('Zeitfenster').all
        zeitfenster.each do |zf|
            db.in('Termin').insert({"Kommentar" => "abwesend", "Lehrkraft" => lid.to_i, "Schueler" => nil, "Zeitfenster" => zf["id"].to_i})
        end
        
#        puts arr.to_s
    end 
    
    redirect to '/'
end