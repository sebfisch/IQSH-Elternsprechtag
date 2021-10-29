# Konsistenzprüfung:
#
# - als Lehrkraft angemeldet
# - istAdmin oder id gehört zu angemeldeter Lehrkraft
#
# Falls konsistent:
#
# - alle Termine (und Pausen) der Lehrkraft mit id löschen und entsprechende Anfragen speichern
# - Gesprächswünsche der Lehrkraft mit id löschen
# - Pausen für alle Zeitfenster eintragen (Kommentar: "krank")

post '/lehrkraft/:id/krank' do |lid|
   if (get_status(current_user) == 'Lehrkraft' && current_user['id'].to_i == lid.to_i) || get_status(current_user) == 'Admin' then
        arr = db.in('Termin').all_where('Lehrkraft = ?', [lid])
        # Für alle Termine 
        arr.each do |termin|
            schueler = termin['Schueler']
            # Gesprächsanfrage erstellen
            if schueler != nil then
                db.in("Anfrage").insert({"Lehrkraft" => lid.to_i, "Schueler" => schueler.to_i})
            end
            # Termine der LK löschen
            db.in('Termin').delete(termin['id'])
            # Zeitfenster der LK als Pause blocken.
            zeitfenster = db.in('Zeitfenster').all
            zeitfenster.each do |zf|
                db.in('Termin').insert({"Kommentar" => "abwesend", "Lehrkraft" => lid.to_i, "Schueler" => nil, "Zeitfenster" => zf["id"].to_i})
            end
        end 
        redirect to '/'
    end
end