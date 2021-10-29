# Konsistenzpruefung

post '/schueler' do
    if (get_status(current_user)!="Admin") then
        redirect to "/"
    end
    s_klasse = params['Klasse']
    s_name = params['Name']
    s_passwort = params['Passwort']
    page 'test', HTML.fragment{
        inline schueler_konsistenz(s_name,s_passwort,s_klasse)
    }
    redirect to '/schueler'
end

def schueler_konsistenz (name, passwort, klasse)
    if klasse != '' && name != '' && passwort != '' && db.in('Schueler').one_where("Name = ?",[name]) == nil then 
        k_id = db.in('Klasse').insert('Bezeichnung' => klasse)
        db.in('Schueler').insert({"Name" => name, "PwHash" => password_hash(passwort), "Klasse" => k_id})
    else 
        text ''
    end
end

