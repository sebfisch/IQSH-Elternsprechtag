#  POST /pause/:id/bearbeiten #37 
# Hinweis: id gehört zu einem Termin-Datensatz.

# Konsistenzprüfung:

#     Lehrkraft zu Termin ist angemeldet
#     Schueler zu Termin ist NULL

# Falls inkonsistent: Weiterleitung GET /

# Sonst:

#     existierenden Termin-Datensatz aus Datenbank abfragen
#     Kommentar überschreiben
#     Datensatz in der Datenbank speichern
#     Weiterleitung GET /

post "/pause/:id/bearbeiten" do
    user = current_user 
    p user
    if user == nil || user["Kuerzel"] == nil then
        redirect to "/"
        
    else
        
        termin = get_termin(params[:id].to_i)
        termin["Kommentar"] =params["Kommentar"] 
        db.in("Termin").set(termin["id"], termin)
        redirect to "/"
    end
    
end


