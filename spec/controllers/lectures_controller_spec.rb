require 'spec_helper'

describe LecturesController do
  context "GEt participation" do
    context "when format is NOT json" do
      before do
        @params = { :lectures => ["1, 2"],
                    :date_start => "2012-02-10",
                    :date_end => "2012-02-11",
                    :format => :html,
                    :locale => "pt-BR" }
      end

      it "should return status conde 406" do
        get :participation, @params

        response.status.should eq(406)
      end

      it "should return any data" do
        get :participation, @params

        response.body.should eq(" ")
      end
    end

    context "when format is json" do
      before do
        @params = { :lectures => ["1, 2"],
                    :date_start => "2012-02-10",
                    :date_end => "2012-02-11",
                    :format => :json,
                    :locale => "pt-BR" }
      end

      it "should return status code 200" do
        get :participation, @params

        response.status.should eq(200)
      end

      context "should return params correctly" do
        before do
          get :participation, @params
          @body = JSON.parse(response.body)
        end

        ['helps', 'answered_helps', 'activities', 'answered_activities',
         'helps_by_day', 'activities_by_day', 'answered_helps_by_day',
         'answered_activities_by_day', 'days'].each do |type|
          it "with total #{type}" do
            proper = @body[type]
            proper.should_not be_nil
          end
        end

        it "with total visualizations" do
          pending "visualizations isn't at db" do
            proper = @body['visualizations']
            proper.should_not be_nil
          end
        end

        it "with total visualizations by day" do
          pending "visualizations isn't at db" do
            proper = @body['visualizations_by_day']
            proper.should_not be_nil
          end
        end
      end
    end
  end
end
