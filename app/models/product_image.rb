class ProductImage < ApplicationRecord

    validates_uniqueness_of :product_id
    validates :title, presence: true
    validates :product_id, numericality: { greater_than: 0 }, presence: true

    def self.import(file)
        items = []
        CSV.foreach(file.path, headers: true) do |row|
            items << row.to_h   
        end
        arr = items[0]
        headers = arr.keys
        headers = headers.collect { |e| e.strip.downcase }
        if (headers.include? "product_id") && (headers.include? "image urls") 
          status = upload_product_image(items,headers)
          return status
        else
          return 406
        end
    end
  
    def self.upload_product_image(items, headers)
      i = 0
      if items.count > 0
        while i < items.count
          j = 0
          product_details = items[i].map { |k, v| [k.strip.downcase, v] }.to_h
          if product_details["image urls"].to_s.present?
            url = product_details["image urls"].split(';') unless product_details["image urls"].to_s.strip.empty?
            if url.count > 0
             while j < url.count
              response = HTTParty.post("https://#{ENV['SHOPIFY_API_KEY']}:#{ENV['SHOPIFY_API_SECRET']}@#{ENV['SHOPIFY_STORE_DOMAIN']}/admin/api/2021-01/products/#{product_details["product_id"]}/images.json", 
              :body => {
                "image": {
                  "src": url[j].strip
                }
              }.to_json,  :headers => { 'Content-Type' => 'application/json' }, timeout: 200)
              if response.code == 422
                return 422, product_details["title"]
              end
              j = j + 1;
             end 
            end
          end
          i = i + 1
        end
      end
      return 300
    end
  
  
      def self.to_csv
          attributes = %w{product_id title handle}
      
          CSV.generate(headers: true) do |csv|
            csv << attributes
      
            all.each do |product|
              csv << attributes.map{ |attr| product.send(attr) }
            end
          end
      end
end
