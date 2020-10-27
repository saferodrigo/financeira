// Load all the controllers within this directory and all subdirectories. 
// Controller files must be named *_controller.js.

import { Application } from 'stimulus'
import { definitionsFromContext } from 'stimulus/webpack-helpers'

// import Flatpickr
import Flatpickr from 'stimulus-flatpickr'

const application = Application.start()
const context = require.context('controllers', true, /_controller\.js$/)
application.load(definitionsFromContext(context))

// Manually register Flatpickr as a stimulus controller
application.register('flatpickr', Flatpickr)

import toastr from 'toastr'
toastr.options = {
  closeButton: true,
  timeOut: 3000,
  fadeOut: 3000,
  preventDuplicates: true,
  positionClass: 'toast-bottom-right'
}
