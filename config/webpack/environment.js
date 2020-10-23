const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append(
  'Provide',
  new webpack.ProvidePlugin({
    $: 'jquery/dist/jquery',
    jQuery: 'jquery/dist/jquery',
    Rails: ['@rails/ujs'],
    Popper: ['popper.js/dist/popper.js', 'popper.js/src/methods/defaults.js']
  })
)

module.exports = environment
