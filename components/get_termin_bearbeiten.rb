# Konsistenzprüfung:

#     Schueler zu Termin ist angemeldet

# Falls inkonsistent: Weiterleitung GET /

# Formular mit vorbelegten Eingabefeldern für Kommentar (Text) und Zeitfenster (Auswahlliste).
# Die Auswahlliste enthält nur die Zeitfenster, an denen die Lehrkraft verfügbar ist (und das aktuell gesetzte Zeitfenster).
# Der übermittelte Wert für das Zeitfenster ist die id des ausgewählten Zeitfensters.
# Speichern-Knopf POST /termin/:id/bearbeiten

get "/termin/:id/bearbeiten" do
    termin = get_termin(params[:id].to_i)      # get_termin in get_pause_bearbeiten.rb
    schueler_id = termin["Schueler"]
    name = db.in("Schueler").one_where("id = ?", [schueler_id])["Name"] #Name des Schülers
    if name == current_user["Name"] && current_user["Kuerzel"] == nil && name != "" then
        termin_bearbeiten(termin)
    else
        redirect to "/"
    end
end

def termin_bearbeiten(termin)
    lehrkraft_id = termin["Lehrkraft"]
    lehrkraft_name = db.in("Lehrkraft").get(lehrkraft_id)["Name"]
    page "Termin bearbeiten", HTML.fragment {
        form(method: "POST") {
            p{
               text "Termin bei: "+ lehrkraft_name
            }
            input(type: "text", name: "Kommentar", placeholder: "Kommentar eingeben", value: termin["Kommentar"])
            select(name: "Zeitfenster", value: termin["Zeitfenster"]) {
                option{text zeitfenster_anzeige(termin["Zeitfenster"])} #vorherige Zeit des Termins
                zeitfenster_finden(lehrkraft_id).each do |zeitfenster| 
                    option {text zeitfenster_anzeige(zeitfenster["id"])} # Zeitfenster müssen noch eingepflegt werden
                end
            }
            input(type: "submit", value: "Speichern")
        }
    }
end

def zeitfenster_finden(lehrkraft)
    zeitfensterliste_id = db.execute("select zeitfenster.id from zeitfenster, termin where zeitfenster.id = termin.Zeitfenster and termin.Lehrkraft = ?",[lehrkraft])
    alle_zeitfenster = db.in("Zeitfenster").all
    puts zeitfensterliste_id
    puts alle_zeitfenster
    ary = alle_zeitfenster.select{|zf| (zeitfensterliste_id.include?("id"=>zf["id"]))==false}
   puts(ary.to_s)
   return ary
end

def zeitfenster_anzeige(id)
    zeitfenster = db.in("Zeitfenster").one_where("id=?", [id])
    "#{zeitfenster['Beginn']}"
end

def get_by_id(db, name, id)
    db.in(name).one_where("id=?", [id])
end

