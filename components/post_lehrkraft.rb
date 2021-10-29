post '/lehrkraft' do
    
    if params['name'] == '' or params['kuerzel'] == '' or params['passwort'] == '' or db.in('Lehrkraft').one_where('Kuerzel = ?', params['kuerzel']) != nil  then 
        
       redirect to '/lehrkraft'
    end

    lid = db.in('Lehrkraft').insert({'Name' => params['name'], 'Kuerzel' => params['kuerzel'], 'PwHash' => password_hash(params['passwort']), 'istAdmin' => (params['istAdmin'] == 'on' ? 1 : 0)})
    
    redirect to "/lehrkraft/#{lid}/bearbeiten"  ##Ist wahrscheinlich richtig, Seite zum testen gibt es (noch) nicht
    
end

