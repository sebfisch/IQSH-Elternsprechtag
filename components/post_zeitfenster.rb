post '/zeitfenster' do 
    erster_beginn = params["Beginn"]
    hh = erster_beginn[0,2].to_i
    min = erster_beginn[3,2].to_i 

    dauer = params["Dauer"].to_i
    anzahl = params["Anzahl"].to_i
    for i in 0..anzahl-1 do
        if hh < 10 then
            hh = "0" + hh.to_s
          end
          if min < 10 then
            min = "0" + min.to_s
        end
        beginn = hh.to_s + "\:" + min.to_s    
        db.in("Zeitfenster").insert({"Beginn" => beginn, "Dauer" => dauer})
        hh = hh.to_i + (min.to_i + dauer.to_i) / 60
        min = (min.to_i + dauer.to_i) % 60
    end
    redirect to '/zeitfenster'
end
