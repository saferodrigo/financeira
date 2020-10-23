import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ["modalCarregando"]

  connect() {
    console.log('conectado')
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
}
