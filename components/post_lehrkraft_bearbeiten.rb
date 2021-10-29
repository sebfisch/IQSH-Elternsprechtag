post '/lehrkraft/:id/bearbeiten', login: true do |lid|
    user = current_user
	if get_status(user)!="Admin" then
		redirect to "/"
    end

    own_path = "/lehrkraft/#{lid}/bearbeiten"

    if params['Kuerzel'] == '' || params['Name'] == "" then
        redirect to own_path
    end
    
    if db.in('Lehrkraft').one_where('Kuerzel = ? and id <> ?', [params['Kuerzel'], lid.to_i]) != nil then
        redirect to own_path
    end
        #Datensatz mit Eingabe überschreiben
    lehrkraft=db.in('Lehrkraft').get(lid.to_i)
    
    if params["Passwort"] != "" then
        lehrkraft["PwHash"] = password_hash(params['Passwort'])
    end

    lehrkraft["Name"]=params['Name']
    lehrkraft["Kuerzel"]=params["Kuerzel"]
    lehrkraft["istAdmin"]=params["istAdmin"]

    db.in('Lehrkraft').set(lid.to_i,lehrkraft)
    redirect to '/lehrkraft'
end
