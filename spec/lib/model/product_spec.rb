require "spec_helper"

describe MadCart::Model::Product do

  before(:each) do
    clear_config
  end

  it "returns the default attributes" do
    attrs = {"external_id" => 'id', "name" => "product name", "description" => 'product description', "price" => '12USD',
             "url" => 'path/to/product', "currency_code" => 'ZAR',
             "image_url" => 'path/to/image', "square_image_url" => 'path/to/square/image'}

    c = MadCart::Model::Product.new(attrs)

    c.attributes.should eql(attrs)
  end

  it "allows attributes to be overwritten" do
    MadCart.configure do |config|
      config.attribute_map :product, {:square_image_url => :thumbnail}
    end

    attrs = {"external_id" => 'id', "name" => "product name", "description" => 'product description', "price" => '12USD',
             "url" => 'path/to/product', "currency_code" => 'ZAR',
             "image_url" => 'path/to/image'}

    c = MadCart::Model::Product.new(attrs.merge(:square_image_url => 'path/to/square/image'))

    c.attributes.should eql(attrs.merge("thumbnail" => 'path/to/square/image'))
  end

  it "exposes all additional attributes provided by the api" do
    attrs = {"external_id" => 'id', "name" => "product name", "description" => 'product description', "price" => '12USD',
             "url" => 'path/to/product', "currency_code" => 'ZAR',
             "image_url" => 'path/to/image', "square_image_url" => 'path/to/square/image'}

    c = MadCart::Model::Product.new(attrs.merge(:with => 'some', :additional => 'fields'))

    c.additional_attributes.should eql({"with" => 'some', "additional" => 'fields'})
  end

  describe "validation" do

    before(:each) do
      @args = {:name => 'name',
               :external_id => 'external_id',
               :description => 'description',
               :price => 'price',
               :url => 'url',
               :currency_code => 'currency_code',
               :image_url => 'image_url',
               :squre_image_url => 'square_image_url'
      }
    end

    it "requires external_id" do
      @args.delete(:external_id)
      lambda{ MadCart::Model::Product.new(@args)  }.should raise_error(ArgumentError)
    end

    it "requires name" do
      @args.delete(:name)
      lambda{ MadCart::Model::Product.new(@args)  }.should raise_error(ArgumentError)
    end

    it "requires description" do
      @args.delete(:description)
      lambda{ MadCart::Model::Product.new(@args)  }.should raise_error(ArgumentError)
    end

    it "requires price" do
      @args.delete(:price)
      lambda{ MadCart::Model::Product.new(@args)  }.should raise_error(ArgumentError)
    end

    it "requires url" do
      @args.delete(:url)
      lambda{ MadCart::Model::Product.new(@args)  }.should raise_error(ArgumentError)
    end

    it "requires currency_code" do
      @args.delete(:currency_code)
      lambda{ MadCart::Model::Product.new(@args)  }.should raise_error(ArgumentError)
    end

    it "requires image_url" do
      @args.delete(:image_url)
      lambda{ MadCart::Model::Product.new(@args)  }.should raise_error(ArgumentError)
    end

    it "requires square_image_url" do
      @args.delete(:square_image_url)
      lambda{ MadCart::Model::Product.new(@args)  }.should raise_error(ArgumentError)
    end

  end
end
