post '/lehrkraft/:id/bearbeiten', login: TRUE do |lid|
    user = current_user
	if get_status(user)!="Admin" then
		redirect to "/"
    end
    
    if params["Kuerzel"] == nil && db.in('Lehrkraft').one_where('Kuerzel = ?', params['Kuerzel']) != nil && params["Name"] == "" then
        redirect to '/lehrkraft/:id/bearbeiten'
    else
         #Datensatz mit Eingabe überschreiben
        lehrkraft=db.in('Lehrkraft').get(lid.to_i)
        
        if params["PwHash"] != nil then
            db.in("Lehrkraft").set(lid.to_i,lehrkraft["PwHash"] = params['PwHash'])
        end

        
        db.in('Lehrkraft').set(lid.to_i,lehrkraft["Name"]=params['Name'], lehrkraft["Kuerzel"]=params["Kuerzel"], lehrkraft["istAdmin"]=params["istAdmin"])
        redirect to '/lehrkraft'

        
    end
    

end
