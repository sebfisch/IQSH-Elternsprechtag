# GET /pause/:id/bearbeiten #36 

# Hinweis: id gehört zu einem Termin-Datensatz.

# Formular mit vorbelegtem Eingabefeld für Kommentar.
# Speichern-Knopf POST /pause/:id/bearbeiten

get "/pause/:id/bearbeiten" do
    termin = get_termin(params[:id].to_i)
    pause_bearbeiten_page(termin)    
end

def pause_bearbeiten_page(termin)
    page "Pause bearbeiten", HTML.fragment{
        form(method: "POST"){
            input(type: "text", name: "Kommentar", placeholder: "Kommentar eingeben", value: termin["Kommentar"])
            input(type: "submit", value: "Speichern")
        }
    }
end

def get_termin(id)
    return db.in("Termin").get(id)
end