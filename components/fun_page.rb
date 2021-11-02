def page titel, inhalt
  logged_in = logged_in?
  if logged_in then
    usr_row = current_user
    status = get_status(usr_row)
  end
  HTML.doc(lang: "de") {
    head {
      meta(charset:'utf-8')
      title { text titel }
      link(
        rel: 'stylesheet', 
        type: 'text/css', 
        href: '/sakura-earthly.css'
      )
    }
    body {
      table {
        tr {
          td {
            if logged_in then
              text usr_row["Name"]
            end     
          }
          td {
            if logged_in then
              inline logout_button 'abmelden', '/logout'
            else
              a(href: '/login') {
                text 'anmelden'
              }
            end
          }
          td { a(href: '/') { text "Startseite" } }
          td {
              if status == 'Admin' then
                  a(href: '/lehrkraft') {
                    text 'Lehrkräfte'
                  }
              end
            
          }
          td {
            if status == 'Admin' then
              a(href: '/schueler') {
                text 'Schüler'
              }
            end      
          }

          td {
            if status == 'Admin' then
              a(href: '/zeitfenster') {
                text 'Zeitfenster'
              }
          end
            
          }
          td {
            if status == 'Admin' then
              a(href: '/phase') {
                text 'Phasen'
              }
          end
            
          }
        }
      }
      
      h1 { text titel }
      inline inhalt
    }
  }
end



def logout_button label, url
  HTML.fragment {
    form(method: 'get', action: url) {
#       input(type: 'hidden', name: '_method', value: 'delete')
      input(type: 'submit', value: label)
    }
  }
end

