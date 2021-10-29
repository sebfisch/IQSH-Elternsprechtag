post '/phase' do 
    config = params['config']
    prioBuchung = params['prioBuchung']
    buchung = params['buchung']
    recall = params['recall']
    confTime=DateTime.new(config[0,4].to_i,config[5,2].to_i,config[8,2].to_i,config[11,2].to_i,config[14,2].to_i)
    prioBuchungTime=DateTime.new(prioBuchung[0,4].to_i,prioBuchung[5,2].to_i,prioBuchung[8,2].to_i,prioBuchung[11,2].to_i,prioBuchung[14,2].to_i)
    buchungTime=DateTime.new(buchung[0,4].to_i,buchung[5,2].to_i,buchung[8,2].to_i,buchung[11,2].to_i,buchung[14,2].to_i)
    recallTime=DateTime.new(recall[0,4].to_i,recall[5,2].to_i,recall[8,2].to_i,recall[11,2].to_i,recall[14,2].to_i)
  #Konsistenzprüfung
  
  if (recallTime<=buchungTime || prioBuchungTime<=recallTime || confTime<=prioBuchungTime ) then
    #redirect to "/phase"
  end
  idConf=db.in('Phase').id_of({'Bezeichnung' => "Konfiguration"})
  idPrioBuchung=db.in('Phase').id_of({'Bezeichnung' => "PrioBuchung"})
  idBuchung=db.in('Phase').id_of({'Bezeichnung' => "Buchung"})
  idAbruf=db.in('Phase').id_of({'Bezeichnung' => "Abruf"})
  db.in("Phase").set(idConf, {'Beginn' => "'#{confTime.to_s}'"})
  db.in("Phase").set(idPrioBuchung, {'Beginn' => "#{prioBuchungTime.to_s}"})
  db.in("Phase").set(idBuchung, {'idBuchung' => "#{buchungTime.to_s}"})
  db.in("Phase").set(idAbruf, {'Beginn' => "'#{recallTime.to_s}'"})
  
  #redirect to "/phase"

end