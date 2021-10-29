# Nicht angemeldet: Weiterleitung `GET /login`
get '/', login: true do
  user = current_user
  role = get_status(user)

  # Angemeldet als Lehrkraft:
  if ["Admin", "Lehrkraft"].include?(role) then
    wuensche = lehrkraft_wuensche(user['id'])
    schueler = lehrkraft_schueler(user['id'])
    zeiten = lehrkraft_zeiten(user['id'])
    lehrkraft_index_page(user, schueler, wuensche, zeiten)
  # Angemeldet als Schueler:
  else
    zeiten = schueler_zeiten(user['id'])
    wuenschende = wuensche_an(user['id'])
    unterrichtende = lehrkraefte_von(user)
    schueler_index_page(user, zeiten, wuenschende, unterrichtende)
  end
end

def lehrkraft_wuensche(user_id)
  wuensche = db.in("Gespraechswunsch").all_where("Lehrkraft = ?", [user_id])
  wuensche.each do |wunsch|
    wunsch["Schueler"] = db.in("Schueler").get(wunsch["Schueler"])
    wunsch["Schueler"]["Klasse"] = db.in("Klasse").get(wunsch["Schueler"]["Klasse"])
  end
  return wuensche
end

def lehrkraft_schueler(user_id)
  schueler = []
  unterricht = db.in('unterrichtet').all_where('Lehrkraft = ?', [user_id])
  unterricht.each do |unt|
    kl_schueler = db.in("Schueler").all_where("Klasse = ?", [unt["Klasse"]])
    schueler = schueler + kl_schueler
  end
  return schueler.uniq
end

def lehrkraft_zeiten(user_id)
  termine = {}
  db.in('Termin').all_where('Lehrkraft = ?', [user_id]).each do |termin|
    if termin['Schueler'] != nil then
      termin['Schueler'] = db.in('Schueler').get(termin['Schueler'])
      termin['Schueler']['Klasse'] = db.in('Klasse').get(termin['Schueler']['Klasse'])
    end
    termine[termin['Zeitfenster']] = termin
  end

  zeiten = db.in('Zeitfenster').all.sort_by { |wunsch| wunsch['Beginn'] }
  zeiten.each do |zeit|
    zeit['Termin'] = termine[zeit['id']]
  end

  return zeiten
end

def lehrkraft_index_page(user, schueler, wuensche, zeiten)
  return page "Elternsprechtag", HTML.fragment {
    # Knopf "krank melden" `POST /lehrkraft/:id/krank`
    form(method: 'post', action: "/lehrkraft/#{user['id']}/krank") {
      input(type: 'submit', value: 'krank melden')
    }

    h2 { text 'Gespächswünsche' }

    # Formular mit Name-Feld und "speichern"-Knopf `POST /wunsch`
    form(method: 'post', action: "/wunsch") {
      input(type: 'text', name: 'Name', placeholder: 'Name', list: 'schueler')
      input(type: 'submit', value: 'speichern')
    }

    # - Auto-Vervollständigung für Name-Feld mit datalist 
    # (alle von der angemeldeten Lehrkraft unterrichteten Schueler, 
    # zu denen noch kein Gesprächswunsch dieser Lehrkraft gespeichert ist)
    wunsch_schueler_ids = wuensche.collect { |wunsch| wunsch['Schueler']['id'] }
    schueler.select! { |sch| !wunsch_schueler_ids.include?(sch['id']) }
    datalist(id: 'schueler') {
      schueler.each do |sch|
        option(value: sch['Name'])
      end
    }

    # Tabelle mit bereits angelegten Gesprächswünschen und den Spalten:
    # - Name
    # - Klasse
    # - Lösch-Knopf `DELETE /wunsch/:id` (id gehört zu Gesprächswunsch)
    table {
      wuensche.each do |wunsch|
        tr {
          td { text wunsch['Schueler']['Name'] }
          td { text wunsch['Schueler']['Klasse']['Bezeichnung'] }
          td { inline delete_button("löschen", "/wunsch/#{wunsch['id']}") }
        }
      end
    }

    h2 { text "Zeitplan" }

    # Tabelle mit allen Zeitfenstern (sortiert nach Beginn) ohne Kopfzeile und Spalten für
    table {
      zeiten.each do |zeit|
        tr {
          td { 
            # - Beginn (ohne Tag)
            text zeit['Beginn']
            inline '&nbsp;'
            text "-" 
            inline '&nbsp;'
            # - Ende (ohne Tag)
            text add_zeit(zeit['Beginn'], zeit['Dauer']) 
          }
          # - Termin (Schuelername, -klasse und Kommentar) bzw. Pause (Kommentar)
          termin = zeit['Termin']
          td {
            if termin != nil then
              schueler = termin['Schueler']
              if schueler != nil then
                text schueler['Name']
                text ' ('
                text schueler['Klasse']['Bezeichnung']
                text '), '
              end
              text termin['Kommentar']
            end
          }
          # - Formular mit Eingabefeld für Kommentar und Knopf "Pause speichern" 
          # `POST /zeitfenster/:id/pause`
          td {
            if termin == nil then
              form(method: 'post', action: "/zeitfenster/#{zeit['id']}/pause") {
                input(type: 'text', name: 'Kommentar', value: 'Pause')
                input(type: 'submit', value: 'speichern')
              }
            else
              # - Lösch-Knopf bei Pause `DELETE /termin/:id`
              if termin['Schueler'] == nil then
                inline delete_button('löschen', "/termin/#{termin['id']}")
              end
            end
          }
        }
      end
    }
  }
end

def add_zeit(zeit, minutes)
  std_min = zeit.split(':').collect { |val| val.to_i }
  std_min[1] = std_min[1] + minutes
  while std_min[1] > 59 do
    std_min[0] = std_min[0] + 1
    std_min[1] = std_min[1] - 60
  end
  while std_min[0] > 23 do
    std_min[0] = std_min[0] - 24
  end
  return std_min.collect do |val|
    res = val.to_s
    if res.size < 2 then "0#{res}" else res end
  end.join(':')
end

def schueler_zeiten(user_id)
  termine = {}
  db.in('Termin').all_where('Schueler = ?', [user_id]).each do |termin|
    termin['Lehrkraft'] = db.in('Lehrkraft').get(termin['Lehrkraft'])
    termine[termin['Zeitfenster']] = termin
  end

  zeiten = db.in('Zeitfenster').all.sort_by { |wunsch| wunsch['Beginn'] }
  zeiten.each do |zeit|
    zeit['Termin'] = termine[zeit['id']]
  end

  return zeiten
end

def wuensche_an(schueler_id)
  wuensche = db.in('Gespraechswunsch').all_where('Schueler = ?', [schueler_id])
  return buchbar_fuer(schueler_id, wuensche)
end

def lehrkraefte_von(schueler)
  unterricht = db.in('unterrichtet').all_where('Klasse = ?', [schueler['Klasse']])
  return buchbar_fuer(schueler['id'], unterricht)
end

def buchbar_fuer(schueler_id, rows)
  result = []

  rows.each do |row|
    termin = db.in('Termin').one_where('Lehrkraft = ? and Schueler = ?', 
      [row['Lehrkraft'], schueler_id])

    if termin == nil then
      lehrkraft = db.in('Lehrkraft').get(row['Lehrkraft'])

      termine = db.in('Termin').all_where('Lehrkraft = ?', [lehrkraft['id']])
      lehrkraft['belegt'] = termine.collect { |termin| termin['Zeitfenster'] }

      result.push(lehrkraft)
    end
  end

  result.uniq!
  return result
end

def schueler_index_page(user, zeiten, wuenschende, unterrichtende)
  phase = 'Buchung' # get_phase
  return page "Elternsprechtag", HTML.fragment {
    # Tabelle mit allen Zeitfenstern (sortiert nach Beginn) ohne Kopfzeile und Spalten für
    table {
      zeiten.each do |zeit|
        tr {
          td { 
            # - Beginn (ohne Tag)
            text zeit['Beginn']
            inline '&nbsp;'
            text "-" 
            inline '&nbsp;'
            # - Ende (ohne Tag)
            text add_zeit(zeit['Beginn'], zeit['Dauer']) 
          }
          # - Termin (Lehrername und Kommentar)
          termin = zeit['Termin']
          td {
            if termin != nil then
              text termin['Lehrkraft']['Name']
              text ', '
              text termin['Kommentar']
            end
          }
          # - Lösch-Knopf bei Termin `DELETE /termin/:id` (auch in Phase Abruf)
          td {
            if termin != nil then
              inline delete_button('löschen', "/termin/#{termin['id']}")
            end
          }
          # - Links für alle buchbaren Lehrkräfte 
          # `GET /lehrkraft/:id/zeitfenster/:id` (nur in Phasen PrioBuchung und Buchung)
          td {
            if termin == nil && ['PrioBuchung', 'Buchung'].include?(phase) then
              buchbar = buchbare_lehrkraefte(phase, zeit['id'], wuenschende, unterrichtende)
              ul {
                buchbar.each do |lehrkraft|
                  li {
                    a(href: "/lehrkraft/#{lehrkraft['id']}/zeitfenster/#{zeit['id']}") {
                      text lehrkraft['Name']
                    }
                  }
                end
              }
            end
          }
        }
      end
    }
  }
end

# Buchbar sind:
# - generell: solche mit denen noch kein Termin vereinbart ist
# - in Phase PrioBuchung: nur solche mit Gesprächswunsch und freiem Zeitfenster
# - in Phase Buchung: alle, die angemeldeten Schueler unterrichten 
#     (oder Gesprächswunsch haben) und im Zeitfenster frei sind
def buchbare_lehrkraefte(phase, zeitfenster_id, wuenschend, unterrichtend)
  result = wuenschend.select do |lehrkraft| 
    !lehrkraft['belegt'].include?(zeitfenster_id)
  end
  if phase == 'Buchung' then
    result = result + unterrichtend.select do |lehrkraft| 
      !lehrkraft['belegt'].include?(zeitfenster_id)
    end
    result.uniq!
  end
  return result
end
