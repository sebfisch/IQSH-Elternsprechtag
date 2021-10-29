# Konsistenzprüfung:
# angemeldet als Lehrkraft
# übermittelter Name gehört zu Schueler, der von angemeldeter Lehrkraft unterrichtet wird
# angemeldete Lehrkraft hat noch keinen Gesprächswunsch zu diesem Schueler gespeichert
# Falls konsistent: Gesprächswunsch von angemeldeter Lehrkraft mit Schueler speichern

# Weiterleitung GET /
post '/wunsch', login: true do 
    name = params["Name"]
    
    if get_status(current_user)=="Lehrkraft" ||  get_status(current_user)=="Admin" then
        l_id = current_user["id"]
        schueler = db.in("Schueler").one_where("Name = ?", [name])
        s_klasse = schueler["Klasse"]
        s_id = schueler["id"]
        # unterrichtet der Lehrer in der Klasse des Schülers?
        if db.in("unterrichtet").one_where("Lehrkraft = ? and Klasse = ?",[l_id, s_klasse]) != nil then
            p "unterrichtet"
            if db.in("Gespraechswunsch").one_where("Lehrkraft = ? and Schueler = ? ",[l_id, s_id]) == nil then
                p "Neuer Wunsch"
                p l_id.to_s
                p s_id.to_s
                db.in("Gespraechswunsch").insert({"Lehrkraft"=> l_id, "Schueler"=> s_id})
            end
        end
    end
    redirect to '/'
end

