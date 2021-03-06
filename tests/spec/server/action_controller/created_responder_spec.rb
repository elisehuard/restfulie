require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe Restfulie::Server::ActionController::CreatedResponder do
  
  context "using a CreatedResponder responder" do
    
    module ToFormatReceiver
      attr_accessor :received
      def to_format
        @received = true
      end
    end

    it "should superize if its not a created result" do
      responder = Object.new
      responder.extend ToFormatReceiver
      responder.extend Restfulie::Server::ActionController::CreatedResponder
      responder.stub(:options).and_return({:status => 300})
      responder.to_format
      responder.received.should be_true
    end

    it "should head if the response is created" do
      should_head_with(:created)
    end
    it "should head if the response is created" do
      should_head_with(201)
    end
    def should_head_with(what)
      uri = "custom_uri"
      resource = Song.new
      controller = Object.new
      controller.should_receive(:url_for).with(resource).and_return(uri)
      
      responder = Object.new
      responder.extend Restfulie::Server::ActionController::CreatedResponder
      responder.stub(:resource).and_return(resource)
      responder.stub(:options).and_return({:status => what})
      responder.should_receive(:controller).and_return(controller)
      responder.should_receive(:head).with(:status => 201, :location => uri)
      responder.to_format
    end
  end

end
