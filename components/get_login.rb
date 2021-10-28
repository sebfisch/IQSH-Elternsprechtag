# # get_login.rb

# ## GET /login
# * Formular zum Einloggen mit Name und Passwort
# -> GET /register


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




