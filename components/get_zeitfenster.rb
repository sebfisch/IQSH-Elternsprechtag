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
        tr{td{text "Datum des ersten Zeitfensters"}
        td{input(type:'date',name:'beginn')}}
        tr{td{text "Anfangszeit des ersten Zeitfensters"}
        td{input(type:'time',name:'beginn', placeholder:'15:00')}}
        tr{td{text "Dauer eines Zeitfensters"}
        td{input(type:'integer',name:'dauer', placeholder:'10')}}
        tr{td{text "Anzahl der Zeitfenster"}
        td{input(type:'integer',name:'anzahl', placeholder:'18')}}
        tr{td{}
        td{input(type:'submit',value:'speichern')}}
      }
    }
  
# Anzeige des Datums (ohne Uhrzeit) irgendeines Zeitfensters



# Tabelle sortierte Zeitfenster (nach Beginn) mit Spalten: 
# Beginn, Ende, Lösch-Knopf (alles ohne Spaltenbeschriftung). 
# Anzeige von Beginn und Ende ohne Datum.
# Lösch-Knopf DELETE /zeitfenster/:id
    text "Hier kommt die Liste der Zeitfenster."
    liste=db.in('zeitfenster').all
    table{
      liste.each do |eintrag|
        tr{td{text eintrag["Beginn"]}
        td{" bis "}
        tr{text eintrag[]}}

      end
    }
    
    



  }
end
end
