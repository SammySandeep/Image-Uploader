class ShopifyController < ApplicationController
    skip_before_action :verify_authenticity_token
    before_action :product_params, only: %i[ update_product ]

    def delete_product
        if ProductImage.exists?(product_id: params["id"])
            product = ProductImage.find_by(product_id: params["id"])
            product.destroy
        end
    end

    def update_product
       product = ProductImage.find_by(product_id: product_params['id'])
       product.title = product_params['title']
       product.product_id = product_params['id']
       product.save
    end

    def product_params
        params.permit!
    end
end
