require 'spec_helper'

describe SubjectsController do
  context "activities" do
    it "should return any data if format is not json" do
      @params = { :subject_id => 1,
                  :format => :html,
                  :locale => "pt-BR" }

      get :activities, @params

      response.body.should eq(" ")
    end

    it "should return params correctly" do
      @params = { :subject_id => 1,
                  :format => :json,
                  :locale => "pt-BR" }

      get :activities, @params

      body = JSON.parse(response.body)
      body.should have(4).items
      subjects = body['helps']
      subjects.should_not be_nil
    end
  end

  context "activities in the d3 bullet chart" do
    it "should return any data if format is not json" do
      @params = { :subject_id => 1,
                  :format => :html,
                  :locale => "pt-BR" }

      get :activities_d3, @params

      response.body.should eq(" ")
    end

    it "should return params correctly" do
      @params = { :subject_id => 1,
                  :format => :json,
                  :locale => "pt-BR" }

      get :activities_d3, @params

      body = JSON.parse(response.body)
      ranges = body['ranges']
      ranges.size.should eq(2)
    end
  end
end
