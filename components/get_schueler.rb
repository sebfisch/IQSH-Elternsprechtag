

get '/schueler' do
    schueler = db.in('Schueler').all
    page 'Schüler anlegen', HTML.fragment {
        inline schueler_form
        inline schueler_table schueler
    }
end

def schueler_form() 
    HTML.fragment{        
        form(method: 'post'){
            div{
                label {text 'Name'}
                input(
                    type: 'text',
                    name: 'Name',
                    placeholder: 'Name',
                )
            }

            div{
                label{text 'Passwort'}
                input(
                    type: 'password',
                    name: 'Passwort',
                    placeholder: 'Passwort',
                )
            }

            div {
                label {text 'Klasse'}
                input(
                    type: 'text',
                    name: 'Klasse',
                    placeholder: 'Klasse', 
                )
            }

            div{
                input(
                    type:'submit', value: 'hinzufügen'
                )
            }
        }
    }
end

def schueler_table schueler
    HTML.fragment{
    table{
        tr{
            th{ text 'Name'}
            th{text 'Klasse '}
            th {text ''}
            th {text ''}
        }
        schueler.each do |schueler| 
            url = "/schueler/#{schueler['id']}/bearbeiten"
            urll = "/schueler/#{schueler['id']}"
            klasse = db.in('Klasse').one_where("id = ?", [schueler['Klasse']])["Bezeichnung"]
        tr {
            td {
                a(href:url){
                text schueler['Name']}
            }
            
            td {text klasse }
            td {inline delete_button('löschen', urll)}
        }
    end         
        
    }
    }
end
#klasse = db.in('Klasse').one_where("id = ?", [Schueler['Klasse']])["Bezeichnung"]
