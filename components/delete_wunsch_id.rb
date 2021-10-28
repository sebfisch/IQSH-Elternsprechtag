# Hinweis: id gehört zu Gesprächswunsch-Datensatz
# Konsistenzprüfung:
# angemeldet als Lehrkraft
# Gesprächswunsch zu id existiert und ist angemeldeter Lehrkraft zugeordnet
# Falls konsistent: Gesprächswunsch mit id aus Datenbank löschen.
# Weiterleitung GET /
delete '/wunsch/:id', login: true do |wid|
    if get_status(current_user)=="Lehrkraft" ||  get_status(current_user)=="Admin" then
        if db.in("Gesprächswunsch").get(wid) != nil then 
            if db.in("Gesprächswunsch").get(wid)["Lehrkraft"] == current_user["id"] then
                db.in("Gesprächswunsch").delete(wid)
            end
        end
    end
    redirect to '/'
end

