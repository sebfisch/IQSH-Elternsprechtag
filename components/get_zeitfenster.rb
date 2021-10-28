get '/zeitfenster' do
  user=current_user
#  status=get_status(user)  
status='Admin'
  if status!="Admin" then
    redirect to '/'
  else

  page "Elternsprechtag - Zeitfenster", HTML.fragment {
    #Formular zum blockweisen Setzen von Zeitfenstern
    #Beginn, Dauer, Anzahl, Speichern-Knopf mit POST /zeitfenster
    text "Blockweises Anlegen von Zeitfenstern"
    p{}
    form(method: 'post'){
      table{
        # tr{
        # td{text "Datum des ersten Zeitfensters"}
        # td{input(type:'date',name:'Datum')} }
        tr{td{text "Anfangszeit des ersten Zeitfensters"}
        td{input(type:'time',name:'Beginn', placeholder:'15:00')}}
        tr{td{text "Dauer eines Zeitfensters"}
        td{input(type:'integer',name:'Dauer', placeholder:'10')}}
        tr{td{text "Anzahl der Zeitfenster"}
        td{input(type:'integer',name:'Anzahl', placeholder:'18')}}
        tr{td{}
        td{input(type:'submit',value:'speichern')}}
      }
    }
  
# Anzeige des Datums (ohne Uhrzeit) irgendeines Zeitfensters



# Tabelle sortierte Zeitfenster (nach Beginn) mit Spalten: 
# Beginn, Ende, Lösch-Knopf (alles ohne Spaltenbeschriftung). 
# Anzeige von Beginn und Ende ohne Datum.
# Lösch-Knopf DELETE /zeitfenster/:id
    p { text "Hier kommt die Liste der Zeitfenster."}
    liste=db.in('Zeitfenster').all
    table{
      liste.each do |eintrag|
        beginn = eintrag["Beginn"]
        dauer = eintrag["Dauer"]
        hh = beginn[0,2].to_i
        min = beginn[3,2].to_i 

        hh = hh + (min + dauer) / 60
        min = (min + dauer) % 60
        if hh < 10 then
          hh = "0" + hh.to_s
        end
        if min < 10 then
          min = "0" + min.to_s
        end
        ende = hh.to_s + "\:" + min.to_s
        tr{
          td{text beginn}
          td{" bis "}
          td{text ende}
          td{ inline delete_button 'löschen', "/zeitfenster/#{eintrag["id"]}" }      
        }
      end
    }
    
    



  }
end
end
