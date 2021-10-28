
post '/schueler/:id/bearbeiten' do |sid|
    url='/schueler/'+sid+'/bearbeiten'
    p sid
  #Konsistenzprüfung
  
  #Name nicht der leere String und nicht mit anderer id verwendet
  if params['Name']=="" then
    redirect to url
  end
  sid2=db.in('Schueler').one_where('Name=?',[params['Name']])
  if sid2!=nil then
    if sid2!=sid then
        redirect to url
    end
  end
  #Klasse nicht der leere String
  if params['Klasse']="" then
    redirect to url
  end
  
  #Name mit Eingabe überschreiben

end
