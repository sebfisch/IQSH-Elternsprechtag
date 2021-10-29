# DELETE /lehrkraft/:id #31 
# Datensatz mit id aus Lehrkraft-Tabelle löschen.
# Löschweitergabe testen (unterrichtet, Gespraechswunsch, Anfrage, Termin) und ggf. programmieren.

# Weiterleitung GET /lehrkraft

delete '/lehrkraft/:id' do |lid|
    db.in('lehrkraft').delete(lid)
    redirect to '/lehrkraft'
end

