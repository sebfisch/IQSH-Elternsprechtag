# # get_login.rb

# ## GET /login
# * Formular zum Einloggen mit Name und Passwort
# -> GET /register

get '/' do
  redirect to '/login'
end

get '/login' do
  page "Login", HTML.fragment {
      inline login_form
    }
end

def login_form(method = 'post')
  # Wir berechnen einen Wahrheitswert, der angibt 
  # ob die HTTP-Methode mit Hilfe eines versteckten Eingabefeldes behandelt werden muss.
  special_method = !['get', 'post'].include?(method)

  # Als Rückgabewert erzeugen wir die HTML-Darstellung eines Formulars.
  # Da das Formular kein action-Attribut definiert,
  # wird die Anfrage an die selbe URL gestellt, auf der das Formular erscheint.
  HTML.fragment {
      form(method: if special_method then 'post' else method end) {
        if special_method then
          input(type: 'hidden', name: '_method', value: method)
        end
        div {
          label { text 'Benutzername:' }
          input(
            type: 'text', 
            size: 42,
            name: 'Benutzername', 
            placeholder: 'Benutzername' 
          )
        }
        div {
          label { text 'Passwort' }
          input(
            type: 'text', 
            name: 'Passwort', 
            placeholder: 'Passwort' 
          )
        }
        
        div {
          input(
            type: 'submit', 
            value: 'Login'
          )
        }

        
      }
    }
end

# ## POST /login
# * Prüfen, ob Name bekannt und Passwort korrekt ist
# * Wenn nicht -> GET /login
# * Falls ja -> Weiterleitung durch Aufruf von login-Funktion

post '/login' do
#   index =  db.in('user').insert({'name' => 'Johannes', 'hash' => password_hash('geheim')})
  username = params['Benutzername']
  password = params['Passwort']
  row_S = db.in('Schueler').one_where("Name = '#{username}'")
  row_L = db.in('Lehrkraft').one_where("Kuerzel = '#{username}'")
  hash = password_hash('')
  if row_S != nil then
      hash = row_S['PwHash']
  elsif row_L != nil then
      hash = row_L['PwHash']
  end

  if valid_password?(password, hash) then
      login(username)
  else
      redirect to '/login'
  end
#  db.in('user').delete(index)
end



# ## GET /logout
# * Abmelden des angemeldeten Nutzers und Weiterleitung mit logout-Funktion

get '/logout' do
  logout
  redirect to '/movies'
end

def get_status
  row_S = db.in('Schueler').one_where("Name = '#{currentuser}'")
  row_L = db.in('Lehrkraft').one_where("Kuerzel = '#{currentuser}'")
  if row_S != nil then
    return "Schueler"
  elsif row_L != nil then
    return "Lehrkraft"
  end
end