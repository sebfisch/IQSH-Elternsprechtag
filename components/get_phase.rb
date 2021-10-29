

get '/phase' do
    if (get_status(current_user)!="Admin") then
        redirect to '/'
    end
    page 'Phasen', HTML.fragment{
        inline phasenseite
    }

end

def phasenseite ()
    HTML.fragment{
        form(method: 'post'){

    table {
      
        tr {
          td { text 'Konfiguration'}
          td {
            input(
                type: 'text', 
                size: 42,
                name: 'config', 
                value: get_configDate  # Time.now.utc.iso8601.to_s
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

        input(
            type: 'submit',           
            value: 'abschicken'
        )
    }
    
    }
end

           
   

def get_configDate ()

    return db.in("Phase").one_where('Bezeichnung = "Konfiguration"')["Beginn"][0,19]
end 

def get_prioDate ()
    return db.in("Phase").one_where('Bezeichnung = "PrioBuchung"')["Beginn"][0,19]
end

def get_bookingDate ()

    return db.in("Phase").one_where('Bezeichnung = "Buchung"')["Beginn"][0,19]
end

def get_recallDate ()

    return db.in("Phase").one_where('Bezeichnung = "Abruf"')["Beginn"][0,19]
end