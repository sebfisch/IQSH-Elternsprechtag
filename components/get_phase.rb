

get '/phase' do
    page 'Phasen', HTML.fragment{
    phasenseite
    }

end

def phasenseite ()
p {
    strong { text 'Phasen:' }
    table {
      
        tr {
          td { text 'Konfiguration' }
          td {
            input(
                type: 'text', 
                size: 42,
                name: 'config', 
                value: get_configDate
              )
             }
         }
        tr { 
            td { text 'PrioBuchung' }
            td {
                input(
                    type: 'text', 
                    size: 42,
                    name: 'prioBuchung', 
                    value: get_prioDate
                )
                }
        }
        tr { 
            td { text 'Buchung' }
            td {
                input(
                    type: 'text', 
                    size: 42,
                    name: 'buchung', 
                    value: get_bookingDate
                  )
            }
        }
        tr { 
            td { text 'Abruf' }
            td {
                input(
                    type: 'text', 
                    size: 42,
                    name: 'recall', 
                    value: get_recallDate
                  )
            }
        }
    }

           
      
    
}
end

def get_configDate ()

    return db.in("Phase").one_where('Bezeichnung = Konfiguration')
end 

def get_prioDate ()
    return db.in("Phase").one_where('Bezeichnung = PrioBuchung')
end

def get_bookingDate ()

    return db.in("Phase").one_where('Bezeichnung = Buchung')
end

def get_recallDate ()

    return db.in("Phase").one_where('Bezeichnung = Abruf')
end