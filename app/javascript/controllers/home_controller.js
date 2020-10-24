import { Controller } from "stimulus"

import toastr from 'toastr'
export default class extends Controller {
  static targets = [
    "modalCarregando", "buttonAcessarConta", "buttonCadastrarConta"
  ]

  connect() {
    console.log('conectado')

    toastr.success('teste')
  }

  exibirModal() {
    $('#modal-carregando').modal({
      backdrop: 'static',
      keyboard: false,
      show: true
    })
  }

  fecharModal() {
    $('#modal-carregando').modal('hide')
  }

  irParaLogin() {
    console.log('aqu')
    Turbolinks.clearCache()
    Turbolinks.visit('/login', {
      action: 'replace'
    })
  }

  irCadastrarUsuario() {
    Turbolinks.clearCache()
    Turbolinks.visit('/usuarios/new', {
      action: 'replace'
    })
  }
}
