# Auto-Vervollständigung für Name-Feld mit datalist (alle von der angemeldeten Lehrkraft unterrichteten Schueler, zu denen noch kein Gesprächswunsch dieser Lehrkraft gespeichert ist)
# Tabelle mit bereits angelegten Gesprächswünschen und den Spalten:

# Name
# Klasse
# Lösch-Knopf DELETE /wunsch/:id (id gehört zu Gesprächswunsch)
# Knopf "krank melden" POST /lehrkraft/:id/krank

# Tabelle mit allen Zeitfenstern (sortiert nach Beginn) ohne Kopfzeile und Spalten für

# Beginn (ohne Tag)
# Ende (ohne Tag)
# Termin (Schuelername, -klasse und Kommentar) bzw. Pause (Kommentar)
# Lösch-Knopf bei Pause DELETE /termin/:id
# Formular mit Eingabefeld für Kommentar und Knopf "Pause speichern" POST /zeitfenster/:id/pause
# Angemeldet als Schueler:

# Tabelle mit allen Zeitfenstern (sortiert nach Beginn) ohne Kopfzeile und Spalten für

# Beginn (ohne Tag)
# Ende (ohne Tag)
# Termin (Lehrername und Kommentar)
# Lösch-Knopf bei Termin DELETE /termin/:id (auch in Phase Abruf)
# Links für alle buchbaren Lehrkräfte GET /lehrkraft/:id/zeitfenster/:id (nur in Phasen PrioBuchung und Buchung)
# Buchbar sind:

# generell: noch solche mit denen noch kein Termin vereinbart ist
# in Phase PrioBuchung: nur solche mit Gesprächswunsch und freiem Zeitfenster
# in Phase Buchung: alle, die angemeldeten Schueler unterrichten (oder Gesprächswunsch haben) und im Zeitfenster frei sind

get '/' do
  logged_in = logged_in?
  user = current_user
  # Nicht angemeldet: Weiterleitung GET /login
  if logged_in == false then
    redirect to '/login'
  else
    status = get_status(user)
  phase = "PrioBuchung"#get_phase()
  page "Elternsprechtag", HTML.fragment {

      # Angemeldet als Lehrkraft:
      if (status=="Lehrkraft" || status == "Admin") then
        text "Schüler zu Gespräch einladen:"
        # Formular mit Name-Feld und "speichern"-Knopf POST /wunsch
        inline gespraechswunsch_form
         # inline Hilfsfunktion, die Tabelle mit den Gesprächswünschen berechnet/zurückliefert 
      end
    }
    end
  
end

def wuensche_lehrkraft
  l_id = current_user["id"]
  meine_wuensche = db.in("Gespraechswunsch").all_where("Lehrkraft = ?", [l_id])
  #hier fehlen noch der Name des Schülers und die Klasse 
end


#Formular um Gesprächswünsche anzulegen
def gespraechswunsch_form(method = 'post')
  
  special_method = !['get', 'post'].include?(method)
  
  HTML.fragment {
    form(method: if special_method then 'post' else method end, action: '/wunsch' )  {
      if special_method then
        input(type: 'hidden', name: '_method', value: method)
      end

      table{
        tr{
          td{
            input(
              type: 'text', 
              size: 42,
              name: 'Name', 
              placeholder: 'Name', 
            )
          }
          td{
            input(
              type: 'submit', 
              value: 'Speichern'
            )
          }
        }
      }
     
    }
  }
end