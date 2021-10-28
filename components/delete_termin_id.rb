delete '/termin/:id', login: true do |tid|
    if get_status(current_user)=="Lehrkraft" ||  get_status(current_user)=="Admin" then
        if db.in("Termin").get(tid)["Lehrkraft"] == current_user["id"] && db.in("Termin").get(tid)["Schueler"]==nil then
            db.in("Termin").delete(tid)
        end
    else
        if get_status(current_user)=="Schueler" then
            if db.in("Termin").get(tid)["Schueler"] == current_user["id"] then
                db.in("Termin").delete(tid)
            end
        end
    end
    redirect to '/'
end

