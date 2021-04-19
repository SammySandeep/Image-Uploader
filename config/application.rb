require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module KlocBulkImageUploader
  class Application < Rails::Application
    
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2
    

    # delete_product_webhook
      HTTParty.post("https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_API_SECRET']}@#{ENV['SHOPIFY_STORE_DOMAIN']}/admin/api/2020-04/webhooks.json",
        :body => {
          "webhook": {
          "topic": "products/delete",
          "address": "#{ENV['URL']}/shopify/delete_product",
          "format": "json"
          }
        }.to_json,  :headers => { 'Content-Type' => 'application/json' })

    # update_product_webhook
      HTTParty.post("https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_API_SECRET']}@#{ENV['SHOPIFY_STORE_DOMAIN']}/admin/api/2020-04/webhooks.json",
        :body => {
          "webhook": {
          "topic": "products/update",
          "address": "#{ENV['URL']}/shopify/update_product",
          "format": "json"
          }
        }.to_json,  :headers => { 'Content-Type' => 'application/json' })
    
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
  end
end
