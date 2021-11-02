# ## POST /login
# * Prüfen, ob Name bekannt und Passwort korrekt ist
# * Wenn nicht -> GET /login
# * Falls ja -> Weiterleitung durch Aufruf von login-Funktion

post '/login' do
      username = params['Benutzername']
      password = params['Passwort']
      row_S = db.in('Schueler').one_where("Name = ?",[username])
      row_L = db.in('Lehrkraft').one_where("Kuerzel = ?",[username])
      hash = password_hash('')
      if row_S != nil then
          hash = row_S['PwHash']
          if valid_password?(password, hash) then
            login(row_S)
            redirect to '/'
          end
      elsif row_L != nil then
          hash = row_L['PwHash']
          if valid_password?(password, hash) then
            login(row_L)
            redirect to '/'
          end
        else
          redirect to '/login'
      end
    
end