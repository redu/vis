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

      it "should return params callback" do
        callback = "myFunct"
        @params.store(:callback, callback)

        get :activities, @params

        response.body.should include "#{callback}("
      end

      context "should return params correctly" do
        before do
          get :activities, @params
          @body = JSON.parse(response.body)
        end

        it "with total helps" do
          proper = @body['helps']
          proper.should_not be_nil
        end

        it "with helps answered" do
          proper = @body['helps_answered']
          proper.should_not be_nil
        end

        it "with helps not answered" do
          proper = @body['helps_not_answered']
          proper.should_not be_nil
        end

        it "with answered helps" do
          proper = @body['answered_helps']
          proper.should_not be_nil
        end

        it "with quantity of subjects finalized" do
          proper = @body['helps_answered']
          proper.should_not be_nil
        end

        it "with quantity of students enrolled" do
          proper = @body['enrollments']
          proper.should_not be_nil
        end
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

      it "should return params callback" do
        callback = "myFunct"
        @params.store(:callback, callback)

        get :activities, @params

        response.body.should include "#{callback}("
      end

      context "should return params correctly" do
        before do
          get :activities_d3, @params
          @body = JSON.parse(response.body)
        end

        it "with ranges" do
          ranges = @body[0]['ranges']
          ranges.size.should eq(1)
        end

        it "with measures" do
          ranges = @body[0]['measures']
          ranges.size.should eq(1)
        end

        it "with markers" do
          ranges = @body[0]['markers']
          ranges.size.should eq(1)
        end
      end
    end
  end
end
