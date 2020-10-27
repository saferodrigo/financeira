import { Controller } from "stimulus"

import swal from 'sweetalert'
import Swal from 'sweetalert2'
export default class extends Controller {
  static targets = [
    "buttonAcessarConta", "buttonCadastrarConta"
  ]

  connect() {}

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
