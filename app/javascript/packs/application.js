// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require('@rails/ujs').start()
require('turbolinks').start()
require('@rails/activestorage').start()
require('channels')

require('jquery')
require('inputmask')

import $ from 'jquery'
import './src/application.scss'
import toastr from 'toastr'
window.toastr = toastr

global.$ = $
global.jQuery = $
global.toastr = toastr

import Rails from '@rails/ujs'
global.Rails = Rails

// jquery-ui theme
require('jquery-ui')

// jQuery Migrate
import 'jquery-migrate/dist/jquery-migrate.min.js'

// jQuery Browser
import 'jquery.browser/dist/jquery.browser.min.js'

// jquery.maskMoney
import '../../assets/javascripts/jquery-maskMoney.jquery.maskMoney.js'

// Bootstrap
import 'bootstrap'
import '@fortawesome/fontawesome-free/js/all'

// SweetAlert 2
import Swal from 'sweetalert2/dist/sweetalert2.js'

import 'sweetalert2/src/sweetalert2.scss'

$(document).on('turbolinks:load', function () {
  let inputMaskCpf = new Inputmask('999.999.999-99')
  let elemCPF = $('#cpf')[0]

  if (elemCPF)
    inputMaskCpf.mask(elemCPF)
})

$(function () {
  $('[data-toggle="popover"]').popover()

  $('[data-toggle="tooltip"]').tooltip({
    trigger: 'click',
    placement: 'bottom' 
  })
})

import 'controllers'
