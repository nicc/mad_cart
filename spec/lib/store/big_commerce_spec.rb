require "spec_helper"

describe MadCart::Store::BigCommerce do
  
  let(:valid_credentials) { 
    { :api_key => '0ff0e3939f5f160f36047cf0caa6f699fe24bdeb',
      :store_url => 'store-cr4wsh4.mybigcommerce.com',
      :username => 'admin' }
  }

  describe "store" do

    it "expects to be instantiated with an api key, username and store url" do
      lambda { MadCart::Store::BigCommerce.new(:username => 'test', :store_url => 'test').connection }.should raise_error(ArgumentError)
      lambda { MadCart::Store::BigCommerce.new(:api_key => 'test', :username => 'test', :store_url => 'test').connection }.should_not raise_error
    end

    it "authenticates via basic auth" do
      connection = Faraday.new
      Faraday.stub!(:new).and_return(connection)

      connection.should_receive(:basic_auth).with('username', 'api_key')

      MadCart::Store::BigCommerce.new(:api_key => 'api_key', :username => 'username', :store_url => 'url').connection
    end

  end
  
  describe "products" do
    
    context "retrieval" do
      
      it "returns all products" do
        VCR.use_cassette('big_commerce') do
          api = MadCart::Store::BigCommerce.new(valid_credentials)
          
          api.products.size.should == 45

          first_product = api.products.first

          first_product.should be_a(MadCart::Model::Product)
          first_product.name.should_not be_nil
          first_product.description.should_not be_nil
          first_product.image_url.should_not be_nil
        end
      end
      
      it "returns an empty array when there are no products" do
        VCR.use_cassette('big_commerce_no_records') do
          api = MadCart::Store::BigCommerce.new(valid_credentials)
          api.products.should == []
        end
      end  
      
    end
    
  end

  describe "customers" do
    context "retrieval" do

      it "returns all customers" do
        VCR.use_cassette('big_commerce', :record => :new_episodes) do
          api = MadCart::Store::BigCommerce.new(valid_credentials)

          api.customers.size.should be > 0
          api.customers.first.should be_a(MadCart::Model::Customer)
        end
      end

      it "returns an empty array whern there are no customers" do
        VCR.use_cassette('big_commerce_no_records') do
          api = MadCart::Store::BigCommerce.new(valid_credentials)

          api.customers.should eql([])
        end
      end

    end
    
    describe "validating credentials" do
      
      it "succeeds if it can get time.json from big commerce" do
        VCR.use_cassette('big_commerce', :record => :new_episodes) do
          api = MadCart::Store::BigCommerce.new(valid_credentials)

          api.should be_valid
        end
      end
      
      it "fails if it cannot get time.json from big commerce" do
        VCR.use_cassette('big_commerce', :record => :new_episodes) do
          api = MadCart::Store::BigCommerce.new(
            :api_key => 'an-invalid-key',
            :store_url => 'store-cr4wsh4.mybigcommerce.com',
            :username => 'admin'
          )

          api.should_not be_valid
        end
      end
      
    end
  end

end
