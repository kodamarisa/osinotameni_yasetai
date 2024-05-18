const { environment } = require('@rails/webpacker')

const webpack = require('webpack')
environment.plugins.append('Provide', new webpack.ProvidePlugin({
  Stimulus: ['@stimulus/core', 'default']
}))

module.exports = environment
