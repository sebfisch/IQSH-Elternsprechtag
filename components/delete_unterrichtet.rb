delete 'unterrichtet/:id', login true do |unt|
    db.in("unterrichtet").delete(unt)
    lid=db.in("unterrichtet").get(unt)["Lehrkraft"]
    
    redirect to '/lehrkraft/' + lid + '/bearbeiten'
end