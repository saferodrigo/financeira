import { Controller } from "stimulus"

import toastr from 'toastr'
import swal from 'sweetalert'

export default class extends Controller {
  static targets = [
    "buttonEncerrarConta"
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

  encerrarConta(event) {
    event.preventDefault()
    event.stopImmediatePropagation()

    const currentTarget = event.target || event.currentTarget
    const href = currentTarget.getAttribute('href')
    const numero = currentTarget.getAttribute('data-numero')
    const wrapper = document.createElement('div')
    wrapper.innerHTML = `<p>Tem certeza de que deseja encerrar a conta n° ${numero}?</p>`

    swal({
      title: 'Atenção!',
      content: wrapper,
      icon: 'warning',
      buttons: ['Cancelar', 'Sim']
    }).then((isConfirm) => {
      if (isConfirm) {
        this.exibirModal()

        Turbolinks.clearCache()
        Turbolinks.visit(href, {
          action: 'replace'
        })
      }
    })
  }
}
