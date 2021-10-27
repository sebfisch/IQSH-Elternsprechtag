def page titel, inhalt
  HTML.doc(charset: 'utf-8') {
    head {
      title { text titel }
      link(
        rel: 'stylesheet', 
        type: 'text/css', 
        href: '/sakura-earthly.css'
      )
    }
    body {
      h1 { text titel }
      inline inhalt
    }
  }
end
