delete '/zeitfenster/:id', login: true do |zid|
    db.in("Zeitfenster").delete(zid)
    redirect to '/zeitfenster'
end

