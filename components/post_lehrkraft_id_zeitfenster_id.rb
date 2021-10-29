# Konsistenzprüfung:

# als Schueler angemeldet
# Lehrkraft ist im Zeitfenster frei
# noch keinen Termin mit Lehrkraft vereinbart
# Phase is PrioBuchung oder Buchung und
# Gesprächswunsch zu Lehrkraft exitiert oder
# Phase ist Buchung und Lehrkraft unterrichtet angemeldeten Schueler
# Falls konsistent: Termin mit übermitteltem Kommentar abspeichern

# Weiterleitung GET /

post '/lehrkraft/:idl/zeitfenster/:idz', login: true do |lid, zid|
    kommentar = params["Kommentar"]
    sid = current_user["id"]
    phase = get_phase
    #phase = "PrioBuchung"
    sklasse = current_user["Klasse"]
    if konsistent_lz?(lid, sid, sklasse, zid, phase) then
        db.in("Termin").insert({"Kommentar"=> kommentar, "Lehrkraft"=> lid.to_i, "Schueler" => sid.to_i, "Zeitfenster"=> zid})
    end
    redirect to '/'
end

def konsistent_lz?(lid, sid, sklasse, zid, phase)
    if lehrkraft_frei?(lid, zid) && keinen_termin_vereinbart?(lid, sid) then
        if phase == "PrioBuchung" || phase == "Buchung" then
            if phase == "PrioBuchung" && hat_gesprachswunsch?(lid, sid)
                return true
            end
            if phase == "Buchung" && db.in("unterrichtet").one_where("Lehrkraft = ? and Klasse = ?", [lid, sklasse]) != nil then
                return true
            end
        end
    end
    return false
end

# hat die Lehrkraft lid im Zeitfenster zid einen freien Termin?
def lehrkraft_frei?(lid, zid)
    return db.in("Termin").one_where("Lehrkraft = ? and Zeitfenster = ?", [lid, zid]) == nil
end

#hat der Lehrer lid noch keinen Termin mit Schüler sid vereinbart?
def keinen_termin_vereinbart?(lid, sid)
    return db.in("Termin").one_where("Lehrkraft = ? and Schueler = ?", [lid, sid]) == nil
end

def hat_gesprachswunsch?(lid, sid)
    return db.in("Gespraechswunsch").one_where("Lehrkraft = ? and Schueler = ?", [lid, sid]) != nil
end