post '/schueler/:id/bearbeiten' do |sid|
  if (get_status(current_user) != "Admin") then
    redirect to "/"
  end

    url='/schueler/'+sid+'/bearbeiten'

    #Konsistenzprüfung
  #Name nicht der leere String und nicht mit anderer id verwendet
  if params['Name']=="" then
    redirect to url
  end
 
  schueler2=db.in('Schueler').one_where('Name=?',[params['Name']])
  if schueler2!=nil then
    if schueler2["id"]!=sid.to_i then
        redirect to url
    end
  end
  #Klasse nicht der leere String
  if params['Klasse']=="" then
    redirect to url
  end
  #Name mit Eingabe überschreiben
  schueler=db.in('Schueler').get(sid.to_i)# Datensatz Schüler
  schueler["Name"]=params['Name']


  if params['Passwort'] != '' then
    schueler['PwHash'] = password_hash params['Passwort']
  end

  schueler['Klasse'] = db.in('Klasse').insert('Bezeichnung' => params['Klasse'])

  
  db.in('Schueler').set(sid.to_i,schueler)
    
  redirect to '/schueler'

end