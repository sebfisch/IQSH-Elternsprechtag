get '/lehrkraft' do
	page 'Lehrkräfte', HTML.fragment {
		inline lehrkraft_formular
		}
end

def lehrkraft_formular 
	HTML.fragment {
		h3 {text 'Neue Lehrkraft anlegen'}
		form(method: 'post') {
			table{
				tr {
					td {
						label { text 'Name' }
					}
					td {
						input(
							type: 'text',
							size: 42,
							name: 'name',
							placeholder: 'Name')
					}
				}
				tr {
					td {
						label { text 'Kürzel' }
					}
					td {
						input(
							type: 'text', 
							size: 3, 
							name: 'kuerzel', 
							placeholder: 'Xxx')
					}
				}
				tr {
					td{
						label { text 'Passwort' }
					}
					td{
						input(
							type: 'password',
							size: 42,
							name: 'passwort',
							placeholder: 'Passwort')
					}
				}
				tr {
					td {
						label { text 'Rolle' }
					}
					td {
						input(
							type: 'checkbox',		# mögliche Werte: on / off
							name: 'istAdmin')
						text ' Admin'
					}
				}
				tr {
					td{}
					td {	
						input(
							type: 'submit',
							value: 'hinzufügen')
					}
						
				}
			}
		}
	}
end

def lehrkraft_liste
	lehrkraefte = db.in('lehrkraft').all


end

