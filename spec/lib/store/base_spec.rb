require "spec_helper"

describe MadCart::Store::Base do
  before(:each) do
    Object.send(:remove_const, :MyStore) if Object.const_defined?(:MyStore)
    class MyStore; include MadCart::Store::Base; end
    class TestResult; end
  end

  describe "connection" do
    it "adds a create_connection_with method" do
      MyStore.should respond_to(:create_connection_with)
    end

    it "accepts a method reference" do
      MyStore.class_eval do
        create_connection_with :connection_method

        def connection_method(args={})
          return TestResult
        end
      end

      MyStore.new.connection.should == TestResult
    end

    it "accepts a proc" do
      MyStore.class_eval do
        create_connection_with Proc.new {|args| TestResult }
      end

      MyStore.new.connection.should == TestResult
    end
    
    it "raises an error if any required connection arguments are not present" do
      MyStore.class_eval do
        create_connection_with Proc.new { }, :requires => [:api_key, :username]
      end
      
      lambda { MyStore.new(:api_key => 'key').connection }.should raise_error(ArgumentError, "Missing connection arguments: username")
    end
  end

  describe "fetch" do
    it "adds a fetch method" do
      MyStore.should respond_to(:fetch)
    end

    it "accepts a method reference" do
      MyStore.class_eval do
        fetch :products, :with => :fetch_method

        def fetch_method
          return [TestResult, TestResult]
        end
      end

      MyStore.new.products.should == [TestResult, TestResult]
    end

    it "accepts a proc" do
      MyStore.class_eval do
        fetch :products, :with => Proc.new { [TestResult, TestResult] }
      end

      MyStore.new.products.should == [TestResult, TestResult]
    end
  end

  describe "format" do
    it "adds a format method" do
      MyStore.should respond_to(:format)
    end

    it "accepts a method reference" do
      MyStore.class_eval do
        fetch :products, :with => Proc.new { [TestResult, TestResult] }
        format :products, :with => :format_method

        def format_method(product)
          return product.to_s
        end
      end

      MyStore.new.products.should == ["TestResult", "TestResult"]
    end

    it "accepts a proc" do
      MyStore.class_eval do
        fetch :products, :with => Proc.new { [TestResult, TestResult] }
        format :products, :with => Proc.new {|product| product.to_s }
      end

      MyStore.new.products.should == ["TestResult", "TestResult"]
    end
  end

  describe "initialize" do

    it "raises an exception on connection if initialize doesn't store the required connection args" do
      class MyStore
        create_connection_with Proc.new { }, :requires => [:args]
        
        def initialize
        end
      end

      o = MyStore.new
      lambda { o.connection }.should raise_error(MadCart::Store::SetupError,
        "It appears MyStore has overrided the default MadCart::Base initialize method. That's fine, but please store any required connection arguments as @init_args for the #connection method to use later. Remember to call #after_initialize in your initialize method should you require it.")
    end

    it "retrieves configured connection arguments"
  end

  describe "after_initialize" do
    it "adds an after_initialize method" do
      MyStore.should respond_to(:after_initialize)
    end

    it "accepts a method reference" do
      MyStore.class_eval do
        after_initialize :init_method
        create_connection_with :connect_method

        def init_method(*args)
          @my_instance_var = args.first[:connection]
        end

        def connect_method(*args)
          return @my_instance_var
        end
      end

      MyStore.new(:connection => TestResult).connection.should == TestResult
    end

    it "accepts a proc" do
      MyStore.class_eval do
        after_initialize Proc.new {|arg| TestResult.new }
        create_connection_with :connect_method

        def connect_method(*args)
          return @my_instance_var
        end
      end
      
      TestResult.should_receive(:new)

      MyStore.new(:connection => TestResult)
    end
  end
end
