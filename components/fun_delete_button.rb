def delete_button label, url
  HTML.fragment {
    form(method: 'post', action: url) {
      input(type: 'hidden', name: '_method', value: 'delete')
      input(type: 'submit', value: label)
    }
  }
end
