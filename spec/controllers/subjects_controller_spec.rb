require 'spec_helper'

describe SubjectsController do
  context "GET activities" do
    context "when format is NOT json" do
      before do
        @params = { :subject_id => 1,
                    :format => :html,
                    :locale => "pt-BR" }
      end

      it "should return status code 406" do
        get :activities, @params

        response.status.should eq(406)
      end

      it "should return any data" do
        get :activities, @params

        response.body.should eq(" ")
      end
    end

    context "when format is json" do
      before do
        @params = { :subject_id => 1,
                    :format => :json,
                    :locale => "pt-BR" }

      end

      it "should return status code 200" do
        get :activities, @params

        response.status.should eq(200)
      end

      it "should return params correctly" do
        get :activities, @params

        body = JSON.parse(response.body)
        body.should have(4).items
        subjects = body['helps']
        subjects.should_not be_nil
      end
    end
  end

  context "GET activities in the d3 bullet chart" do

    context "when format is NOT json" do
      before do
        @params = { :subject_id => 1,
                    :format => :html,
                    :locale => "pt-BR" }
      end

      it "should return status code 406" do
        get :activities_d3, @params

        response.status.should eq(406)
      end

      it "should return any data" do
        get :activities_d3, @params

        response.body.should eq(" ")
      end
    end

    context "when format is json" do
      before do
        @params = { :subject_id => 1,
                    :format => :json,
                    :locale => "pt-BR" }

      end

      it "should return status code 200" do
        get :activities_d3, @params

        response.status.should eq(200)
      end

      it "should return params correctly" do
        get :activities_d3, @params

        body = JSON.parse(response.body)
        ranges = body['ranges']
        ranges.size.should eq(2)
      end
    end
  end
end
