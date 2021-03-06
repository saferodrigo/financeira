import { Controller } from "stimulus"

import swal from 'sweetalert'
import Swal from 'sweetalert2'

export default class extends Controller {
  static targets = [
    "id", "buttonEncerrarConta", "buttonTransferencia", "inputDataInicio", "inputDataFim"
  ]

  connect() {}

  _maskMoney() {
    $("#currency").maskMoney({
      prefix: 'R$ ',
      thousands: '.',
      decimal: ',',
      affixesStay: true,
      allowZero: false,
      allowNegative: false
    })
  }

  msgError(msg) {
    Swal.fire({
      title: 'Atenção!',
      html: msg,
      icon: 'warning',
      allowOutsideClick: false
    })
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

  encerrarConta(event) {
    event.preventDefault()
    event.stopImmediatePropagation()

    const currentTarget = event.target || event.currentTarget
    const href = currentTarget.getAttribute('href')
    const numero = currentTarget.getAttribute('data-numero')
    const wrapper = document.createElement('div')
    let innerHTML = `Tem certeza de que deseja encerrar a conta n° ${numero}?`
    innerHTML += '<p>Esta ação não poderá ser desfeita.</p>'

    Swal.fire({
      title: 'Atenção!',
      html: innerHTML,
      icon: 'warning',
      showCancelButton: true,
      cancelButtonText: 'Cancelar'
    }).then((data) => {
      if (data.isConfirmed) {
        this.exibirModal()

        Turbolinks.clearCache()
        Turbolinks.visit(href, {
          action: 'replace'
        })
      }
    })
  }

  movimentacao(event) {
    event.preventDefault()
    event.stopImmediatePropagation()
    let maskMoneyFunction = this._maskMoney

    const currentTarget = event.target || event.currentTarget
    let href = currentTarget.getAttribute('href')
    let tipo = currentTarget.getAttribute('data-tipo')

    Swal.fire({
      title: 'Atenção!',
      text: `Digite o valor do ${tipo}:`,
      input: 'text',
      inputAttributes: {
        id: 'currency',
        placeholder: 'R$ 0,00'
      },
      icon: 'warning',
      didOpen: function (el) {

        setTimeout(() => {
          maskMoneyFunction()
        }, 500)

      },
      showCancelButton: true,
      cancelButtonText: 'Cancelar'
    }).then((data) => {

      if (data.isConfirmed) {

        if (data.value && data.value != 'R$ 0,00') {

          href += `&valor=${data.value}`

          this.exibirModal()
          
          setTimeout(() => {
            Turbolinks.clearCache()
            Turbolinks.visit(href, {
              action: 'replace'
            })
          }, 2000);

        } else {
          this.msgError(`Valor para o ${tipo} deve ser maior que zero.`)
        }
 
      }
    })
  }

  transferencia(event) {
    event.preventDefault()
    event.stopImmediatePropagation()

    const currentTarget = event.target || event.currentTarget
    let href = currentTarget.getAttribute('href')
    let idValue = this.idTarget.value
    let exibirModalTarget = this.exibirModal
    let fecharModalTarget = this.fecharModal
    let msgErrorTarget = this.msgError
    let maskMoneyFunction = this._maskMoney

    Swal.fire({
    title: 'Atenção!',
    text: 'Digite o CPF do usuário para efetuar a transferência:',
    icon: 'warning',
    input: 'text',
    inputAttributes: {
      id: 'cpf'
    },
    didOpen: function (el) {

      let cpf = document.getElementById('cpf')
      let inputMaskCpf = new Inputmask('999.999.999-99')

      setTimeout(() => {
        inputMaskCpf.mask(cpf)
      }, 500)
    }
    }).then((data) => {
      if (data.isConfirmed) {

        if (data.value && data.value.split('_').length == 1) {

          exibirModalTarget()

          $.ajax({
            url: `/usuarios/usuario_por_cpf?cpf=${data.value}`,
            method: 'GET',
            success: function (data) {
              setTimeout(function () {
                fecharModalTarget()
                data = JSON.parse(data)

                if (data && data.presente == true) {

                  if (data.usuario.id == idValue) {

                    msgErrorTarget('Não é possível transferir para própria conta. Tente fazer um <b>depósito</b>.')

                  } else if (!data.usuario.conta.ativa) {

                    msgErrorTarget(`Cliente ${data.usuario.nome} está <strong class='text-danger'>DESATIVADO</strong> e não é possível efetuar a transferência.`)

                  } else {

                    href += `&conta_id=${data.usuario.conta.id}`

                    let innerHTML = `Transferindo para <strong>${data.usuario.nome}</strong> - CPF: <strong>${data.usuario.cpf}</strong>, conta n° <strong>${data.usuario.conta.numero}</strong>.`
                    innerHTML += '<p class="text-danger" title="Confira a seção TAXAS DE TRANSFÊNCIAS">Sujeito à taxa de transferência*</p><br/><br/>'
                    innerHTML += '<label for="currency">Digite o valor da transfência: </label>'

                    Swal.fire({
                      title: 'Atenção!',
                      html: innerHTML,
                      input: 'text',
                      inputAttributes: {
                        id: 'currency',
                        placeholder: 'R$ 0,00'
                      },
                      icon: 'warning',
                      didOpen: function (el) {

                        setTimeout(() => {
                          maskMoneyFunction()
                        }, 1000)

                      },
                      showCancelButton: true,
                      cancelButtonText: 'Cancelar'
                    }).then((data) => {

                      if (data.isConfirmed) {

                        if (data.value && data.value != 'R$ 0,00') {

                          href += `&valor=${data.value}`

                         exibirModalTarget()

                          setTimeout(() => {

                            Turbolinks.clearCache()
                            Turbolinks.visit(href, {
                              action: 'replace'
                            })

                          }, 2000);

                        } else {
                          this.msgError(`Valor para o ${tipo} deve ser maior que zero.`)
                        }

                      }
                    })
                  }

                } else {

                  msgErrorTarget('Cliente não cadastrado no nosso sistema.')

                }

              }, 500)
            },
            error: function (error) {

              setTimeout(function () {
                fecharModalTarget()
                msgErrorTarget(error)
              }, 500)

            }
          })

        } else {
          this.msgError('CPF inválido.')
        }

      }
    })
  }

  filtrarExtrato(event) {
    event.preventDefault()
    event.stopImmediatePropagation()

    const currentTarget = event.target || event.currentTarget
    const form = document.getElementById('form-filtro-extrato')
    let urlSearchExtrato = form.getAttribute('action')
  
    if (this.inputDataInicioTarget.value && this.inputDataFimTarget.value) {

      if (this._transformDate(this.inputDataInicioTarget.value) <= this._transformDate(this.inputDataFimTarget.value)) {

        urlSearchExtrato += `?data_inicio=${this.inputDataInicioTarget.value}&data_fim=${this.inputDataFimTarget.value}`

        $.ajax({
          url: urlSearchExtrato,
          method: 'GET',
          success: function (data) {
            // console.log('success', data)
          },
          error: function (error) {
            // console.log('error', error)
          }
        })

      } else {
        this.msgError('Data início deve ser igual ou superior à data fim')
      }

    } else {
      this.msgError('Preencha as datas início e fim.')
    }
  }

  _transformDate(dateStr) {
    dateStr = dateStr.replaceAll('-', '/')

    return new Date(dateStr)
  }
}
