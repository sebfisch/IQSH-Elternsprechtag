# GET /schueler/:id/bearbeiten
# Formular mit vorausgefüllten Feldern für Name und Klasse. Passwort-Feld leer.
# Speichern-Knopf POST /schueler/:id/bearbeiten

get '/schueler/:id/bearbeiten' do |sid|
    if (get_status(current_user)=="Admin") then
        schueler = db.in('Schueler').get(sid)
        url = "/schueler/"+sid+"/bearbeiten"
        
        page 'Schuelerdaten bearbeiten', HTML.fragment {
            form(method: 'post', action: url) {
                div {  
                    label { text 'Name' }          
                    input(type: 'text', name: 'Name',  value: schueler['Name'])
                }
                div{
                    label { text 'Klasse' }  
                    input(type: 'text', name: 'Klasse',  value: db.in('Klasse').get(schueler['Klasse'].to_i)["Bezeichnung"])
                }
                div {
                    label { text 'Passwort, leer wenn es das alte bleiben soll' }
                    input(type: 'text', name: 'Passwort', value: "")
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

