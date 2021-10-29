delete '/schueler/:id' do |sid|
	if (get_status(current_user)=="Admin") then
		db.in('Schueler').delete(sid)
	end
	redirect to '/schueler'
end