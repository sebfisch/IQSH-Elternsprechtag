#Knopf "krank melden" POST /lehrkraft/:id/krank

get '/lehrkraft/:id/bearbeiten' do |lid|        
        page "Lehrkraftdaten bearbeiten", HTML.fragment { 
            url = "/lehrkraft/#{lid}/krank"
            lehrer = db.in("Lehrkraft").get(lid)
            form(method: 'post', action: url) {            
                div {
                    input(type: 'submit', value: "krank melden")
                }
            }

            url = "/lehrkraft/#{lid}/bearbeiten"
            form(method: 'post', action: url) {
                div {  
                    label { text 'Name'}          
                    input(type: 'text', name: 'Name',  value: lehrer['Name'])
                }
                
                div {  
                    label { text 'Kürzel'}          
                    input(type: 'text', name: 'Kuerzel',  value: lehrer['Kuerzel'])
                }

                div {  
                    label { text 'Passwort leer lassen, wenn es gleich bleiben soll'}          
                    input(type: 'passwort', name: 'Passwort') 
                }

                #tobo is admin aus db holen und als value anlegen
                div{
                    label { text 'Ist Admin'}          
                input(
							type: 'checkbox',		# mögliche Werte: on / off
                            name: 'istAdmin',
                            value: (if(lehrer['istAdmin']==1)then "on" else "off" end))
            }
                #tobo klassen in Klartext aus den db holen und als csc string  in value übergeben
                div {  
                    label { text 'Klassen'}          
                    input(type: 'text', name: 'Klassen') 
                }
            
                div {
                    input(type: 'submit', value: "Speichern")
                }
            }




        }           
        #redirect to '/lehrkraft/:id/krank'
end



#Formular mit vorausgefüllten Feldern für Name, Kuerzel, istAdmin. Leeres Passwort-Feld.

#Speichern-Knopf POST /lehrkraft/:id/bearbeiten

#Formular mit einem Eingabefeld für eine Klasse.
#Knopf "hinzufügen" POST /unterrichtet/:id (Id der Lehrkraft)

#Liste mit Klassen, in denen die Lehrkraft unterrichtet mit Lösch-Knopf DELETE /unterrichtet/:id (Id des Datensatzes aus der Tabelle für die Beziehung "unterrichtet")