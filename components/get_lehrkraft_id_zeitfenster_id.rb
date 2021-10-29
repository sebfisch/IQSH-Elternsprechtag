get '/lehrkraft/:idl/zeitfenster/:idz', login: true do |lid, zid|

    name_lk = db.in("Lehrkraft").get(lid)["Name"]
    beginn = db.in("Zeitfenster").get(zid)["Beginn"]
    p name_lk
    p beginn
    page 'Gesprächstermin vereinbaren', HTML.fragment {
        inline lehrkraft_zeitfenster_header(name_lk, beginn)
        inline lehrkraft_zeitfenster_formular
    }
end

def lehrkraft_zeitfenster_header(name_lk, beginn) 
	HTML.fragment {
        table {
            tr {
                th {text "Name der Lehrkraft"}
                th {text "Beginn"}
            }
            tr {
                td {text name_lk}
                td {text beginn}
            }
        }
    }
end

def lehrkraft_zeitfenster_formular
    HTML.fragment {
        form(method: 'post') {
            table {
                tr {
                td {
                input(
                    type: 'text',
                    size: 42,
                    name: 'Kommentar',
                    placeholder: 'Kommentar eingeben')
                }
                td {
                input(
                    type: 'submit',
                    value: 'Termin vereinbaren')
                }
                }
        }
    }
    }
end