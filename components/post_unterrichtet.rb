# Hinweis: id gehört zu einem Lehrkraft-Datensatz.


post 'unterrrichtet/:id' do |lid|
    klasse = params["Klasse"] #Name des Eingabefeldes ggf anpassen
    # Id der eingegebenen Klasse bestimmen (ggf. neu anlegen)
    klasse_id = db.in("Klasse").one_where("Bezeichnung = ?", [klasse])["id"]
    if klasse_id == nil then
        db.in('Klasse').insert({'Bezeichnung' => klasse})
    end
    # Neuen Datensatz für "unterrichtet"-Tabelle erzeugen aus id der Lehrkraft und id der Klasse.
    db.in("unterrichtet").insert({"Lehrkraft" => lid, "Klasse"=> klasse_id})
    # Weiterleitung GET /lehrkraft/:id/bearbeiten
    redirect to '/lehrkraft/' + lid + '/bearbeiten'
end