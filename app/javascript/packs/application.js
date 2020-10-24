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

$(document).on('turbolinks:load', function () {
  var inputmask = new Inputmask('999.999.999-99')
  var elem = $('#cpf')[0]

  if (elem)
    inputmask.mask(elem)
})

import $ from 'jquery'
import toastr from 'toastr'

global.$ = $
global.jQuery = $
global.toastr = toastr

import Rails from '@rails/ujs'
global.Rails = Rails

import 'bootstrap'
import '@fortawesome/fontawesome-free/js/all'

import 'controllers'
