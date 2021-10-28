# ## GET /logout
# * Abmelden des angemeldeten Nutzers und Weiterleitung mit logout-Funktion

get '/logout' do
    logout
    redirect to '/'
end
