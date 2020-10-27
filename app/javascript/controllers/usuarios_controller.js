import { Controller } from "stimulus"

import swal from 'sweetalert'
import Swal from 'sweetalert2'

export default class extends Controller {
  static targets = [
    "id", "cpf", "buttonGerarCPF"
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

  msgError(msg) {
    Swal.fire({
      title: 'Atenção!',
      text: msg,
      icon: 'warning',
      allowOutsideClick: false
    })
  }

  gerarCPF() {
    let cpf = this.cpfTarget
    let fecharModalTarget = this.fecharModal

    this.exibirModal()
    $.ajax({
      url: '/usuarios/gerar_cpf',
      method: 'GET',
      success: function (data) {
        setTimeout(function () {
          cpf.value = data
          fecharModalTarget()
        }, 500)
      },
      error: function (error) {
        setTimeout(function () {
          fecharModalTarget()
          msgError(error)
        }, 500)
      }
    })
  }

  salvar(event) {
    event.preventDefault()
    event.stopImmediatePropagation()
    
    const form = document.getElementById('form-usuario')

    if (form.checkValidity()) {

      if (this.idTarget.value || this.idTarget.value != '') {
        Swal.fire({
          title: 'Atenção!',
          text: 'Tem certeza que deseja confirmar estas alterações no cadastro da sua conta?',
          icon: 'warning',
          showCancelButton: true,
          cancelButtonText: 'Cancelar'
        }).then((data) => {
          if (data.isConfirmed) {
            form.submit()
          }
        })

      } else {
        form.submit()
      }

    } else {
      this.msgError('Preencha todos os campos obrigatórios.')
    }
  }
}
