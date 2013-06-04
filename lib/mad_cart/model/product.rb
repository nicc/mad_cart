module MadCart
  module Model
    class Product
      include MadCart::Model::Base

       required_attributes :external_id, :name, :description, :price, :url, :currency_code, :image_url, :square_image_url
    end
  end
end
