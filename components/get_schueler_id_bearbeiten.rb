# GET /schueler/:id/bearbeiten
# Formular mit vorausgefüllten Feldern für Name und Klasse. Passwort-Feld leer.
# Speichern-Knopf POST /schueler/:id/bearbeiten

get '/schueler/:id/bearbeiten' do |sid|
    if (get_status(current_user)=="Admin") then
        schueler = db.in('Schueler').get(sid)
        url = "/schueler/:"+sid+"/bearbeiten"
        
        page 'Schuelerdaten bearbeiten', HTML.fragment {
            form(method: 'post', action: url) {
                div {            
                    input(type: 'text', name: 'Name', placeholder: 'Name', value: schueler['Name'])
                }
                div{
                    input(type: 'text', name: 'Klasse', placeholder: 'Klasse', value: db.in('Klasse').get(schueler['Klasse'].to_i)["Bezeichnung"])
                }
                div {
                    input(type: 'text', name: 'Passwort', placeholder: 'Passwort, leer wenn nicht zu ändern',value: "")
                }
                div {
                    input(type: 'submit', value: "Speichern")
                }
            }
        }           
    else
        redirect to '/'
    end

end

