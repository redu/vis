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

        it "with total helps" do
          proper = @body['helps']
          proper.should_not be_nil
        end

        it "with total answered helps" do
          proper = @body['answered_helps']
          proper.should_not be_nil
        end

        it "with total activities" do
          proper = @body['activities']
          proper.should_not be_nil
        end

        it "with total answered activities" do
          proper = @body['answered_activities']
          proper.should_not be_nil
        end

        it "with total visualizations" do
          pending "visualizations isn't at db" do
            proper = @body['visualizations']
            proper.should_not be_nil
          end
        end

        it "with helps by day" do
          proper = @body['helps_by_day']
          proper.should_not be_nil
        end

        it "with answered helps by day" do
          proper = @body['answered_helps_by_day']
          proper.should_not be_nil
        end

        it "with activities by day" do
          proper = @body['activities_by_day']
          proper.should_not be_nil
        end

        it "with answered activities by day" do
          proper = @body['answered_activities_by_day']
          proper.should_not be_nil
        end

        it "with days" do
          proper = @body['days']
          proper.should_not be_nil
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
