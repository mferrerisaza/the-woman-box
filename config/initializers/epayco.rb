require 'epayco-ruby'

Epayco.apiKey = ENV['EPAYCO_PUBLIC_KEY']
Epayco.privateKey = ENV['EPAYCO_PRIVATE_KEY']
Epayco.lang = 'ES'
Epayco.test = true
