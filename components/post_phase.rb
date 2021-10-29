post '/phase' do 

  if (get_status(current_user)!="Admin") then
    redirect to '/'
  end
  
    config = params['config']
    prioBuchung = params['prioBuchung']
    buchung = params['buchung']
    recall = params['recall']
    confTime=DateTime.new(config[0,4].to_i,config[5,2].to_i,config[8,2].to_i,config[11,2].to_i,config[14,2].to_i)
    prioBuchungTime=DateTime.new(prioBuchung[0,4].to_i,prioBuchung[5,2].to_i,prioBuchung[8,2].to_i,prioBuchung[11,2].to_i,prioBuchung[14,2].to_i)
    buchungTime=DateTime.new(buchung[0,4].to_i,buchung[5,2].to_i,buchung[8,2].to_i,buchung[11,2].to_i,buchung[14,2].to_i)
    recallTime=DateTime.new(recall[0,4].to_i,recall[5,2].to_i,recall[8,2].to_i,recall[11,2].to_i,recall[14,2].to_i)
  
    #Konsistenzprüfung
  
  if (recallTime<=buchungTime || buchungTime<=prioBuchungTime || prioBuchungTime<=confTime) then
    redirect to "/phase"
  end

  idConf=db.in("Phase").one_where('Bezeichnung=?',['Konfiguration'])["id"]
  datensatzConf=db.in("Phase").get(idConf)
  datensatzConf["Beginn"]=confTime.to_s
  db.in("Phase").set(idConf,datensatzConf)

  idPrioBuchung=db.in("Phase").one_where('Bezeichnung=?',['PrioBuchung'])["id"]
  datensatzPrioBuchung=db.in("Phase").get(idPrioBuchung)
  datensatzPrioBuchung["Beginn"]=prioBuchungTime.to_s
  db.in("Phase").set(idPrioBuchung,datensatzPrioBuchung)
 
  idBuchung=db.in("Phase").one_where('Bezeichnung=?',['Buchung'])["id"]
  datensatzBuchung=db.in("Phase").get(idBuchung)
  datensatzBuchung["Beginn"]= buchungTime.to_s
  db.in("Phase").set(idBuchung,datensatzBuchung)

  idAbruf=db.in("Phase").one_where('Bezeichnung=?',['Abruf'])["id"]
  datensatzAbruf=db.in("Phase").get(idAbruf)
  datensatzAbruf["Beginn"]=recallTime.to_s
  db.in("Phase").set(idAbruf,datensatzAbruf)
   
  redirect to "/phase"

end