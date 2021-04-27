class ProductImagesController < ApplicationController
    before_action :set_product_image, only: %i[ destroy ]
    skip_before_action :verify_authenticity_token

    def index
      @product_images = ProductImage.all
      respond_to do |format|
        format.html
        format.csv { send_data @product_images.to_csv, filename: "products-#{Date.today}.csv" }
      end
    end
  
    def all_products
      all_products = HTTParty.get("https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_API_SECRET']}@#{ENV['SHOPIFY_STORE_DOMAIN']}/admin/api/2021-01/products.json?fields=id,title,handle,status&limit=250")
      all_products["products"].each do |product|
        if product["status"] == "active"
          ProductImage.create(
                          product_id: product["id"],
                          title: product["title"] ,
                          handle: product["handle"]
                          )
        end
      end
      redirect_to product_images_path
    end
  
    def import
      file = params[:file]
      if file.nil?
        redirect_to import_csv_path, notice: "CSV document not present."
      else
        status = ProductImage.import(file)
        if status == 406
            redirect_to product_images_path, notice: "Missing 'Product IDs' or 'Image Urls' columns for the file!"
        elsif status[0] == 422
            redirect_to product_images_path, notice: "Invalid Image Url provided for product #{status[1]}"
        else 
            redirect_to product_images_path, notice: "All Images are uploaded"
        end
      end   
    end

    def destroy
      @product_image.destroy
      respond_to do |format|
        format.html { redirect_to product_images_url, notice: "Product image was successfully destroyed." }
        format.json { head :no_content }
      end
    end

    def delete_multiple
      ProductImage.destroy(params[:product_image_ids])
      respond_to do |format|
        format.html { redirect_to product_images_path, notice: 'Products were successfully deleted.' }
        format.json { head :no_content }
      end
    end
  
    private
      def set_product_image
        @product_image = ProductImage.find(params[:id])
      end
  
      def product_image_params
        params.require(:product_image).permit(:product_id, :title, :handle)
      end
end
