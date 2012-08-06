require 'spec_helper'

describe SubjectsController do
  context "GET activities" do
    context "when format is NOT json" do
      before do
        @params = { :subjects => ["1", "2"],
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
        @params = { :subjects => ["1"],
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

        ['helps', 'helps_answered', 'helps_not_answered',
         'answered_helps', 'subjects_finalized',
         'enrollments'].each do |type|
           it "with total #{type}" do
             proper = @body[type]
             proper.should_not be_nil
           end
         end
      end
    end
  end
end
