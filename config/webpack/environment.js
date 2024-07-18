const { environment } = require('@rails/webpacker')

environment.plugins.append('Provide', new webpack.ProvidePlugin({
  Popper: ['popper.js','default']
}))

module.exports = environment
