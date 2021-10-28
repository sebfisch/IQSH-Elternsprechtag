post '/lehrkraft' do #|lehrkraft|
   # if params['name'] == '' or params['kuerzel'] == '' or params['passwort'] == '' or db.in('lehrkraft').one_where("Kuerzel = ?", params['kuerzel']) != [] then 
    #    redirect to '/lehrkraft'
    #end

    lid= db.in('Lehrkraft').insert({'Name' => params['name'], 'Kuerzel' => params['kuerzel'], 'PwHash' => password_hash(params['passwort']), 'istAdmin' => (params['istAdmin'] == 'on' ? 1 : 0)})
    
    redirect to '/lehrkraft/:lid/bearbeiten'

end