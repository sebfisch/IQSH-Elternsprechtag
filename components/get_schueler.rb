#require "html"
#require "sinatra"
#require_relative "db/database_sqlite"
#require_relative "authentication"

get '/schueler' do
    page 'Schüler anlegen', HTML.fragment {
        inline schueler_form
        #inline schueler_table
    }
end

def schueler_form() # hier muss noch mehr hin
    HTML.fragment{
        form(method: 'post'){
            div{
                label {text 'Name'}
                input(
                    type: 'text',
                    name: 'Name',
                    placeholder: 'Name',
                    #value: schueler['Name']
                )
            }

            div{
                label{text 'PwHash'}
                input(
                    type: 'text',
                    name: 'Passwort',
                    placeholder: 'Passwort',
                    #value: password_hash(password)      #?
                )
            }

            div {
                label {text 'Klasse'}
                input(
                    type: 'text',
                    name: 'Klasse',
                    placeholder: 'Klasse',
                    #value: schueler['Klasse']
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

# def schueler_table schueler
#     HTML.fragment{
#     table{
#         tr{
#             th{ text 'Name'}
#             th{text 'Klasse '}
#             th {text ''}
#             th {text ''}
#         }

#         tr {
#             td {text schueler['Name']}
#             td {text schueler['Klasse']}
#             td {inline delete_schueler('löschen', url)}
#         }
            
        
#     }
#     }

# end
