require 'spec_helper'

describe DatabaseHierarchyNotificationsController do
  context "POST create" do
    before do
      # Factory.build(:hierarchy_notification)
      @params = {:database_hierarchy_notification =>
                 {:user_id => 1, :lecture_id => 1,
                  :subject_id => 1, :space_id => 1,
                  :course_id => 1, :status_id => nil,
                  :statusable_id => nil,
                  :statusable_type => nil, :in_response_to_id => nil,
                  :in_response_to_type => nil, :type => "subject_finalized" },
                  :format => "json"}
    end

    context "when authorized" do
      before do
       @request.env["HTTP_AUTHORIZATION"] = "Basic " + Base64::encode64("core-team:JOjLeRjcK")
      end

      it "should assign a @hierarchy variable" do
        post :create, @params
        assigns[:hierarchy].should_not be_nil
        assigns[:hierarchy].should be_a(HierarchyNotification)
      end

      it "should assign a valid @hierarchy variable" do
        post :create, @params
        assigns[:hierarchy].should be_valid
      end

      context "if notification already exists" do
        it "should respons with code 304 Not Modified " do
          h = HierarchyNotification.new(:user_id => 1, :lecture_id => 1,
                                        :subject_id => 1, :space_id => 1,
                                        :course_id => 1, :status_id => nil,
                                        :statusable_id => nil,
                                        :statusable_type => nil,
                                        :in_response_to_id => nil,
                                        :in_response_to_type => nil,
                                        :type => "subject_finalized")
          h.save!

          post :create, @params
          response.code.should == "204"
        end
      end

      context "if notification doesn't exist and well formated" do
        it "should responds within code 201 OK" do
          post :create, @params
          response.code.should == "201"
        end

        it "should create a hierarchy notification" do
          expect {
            post :create, @params
          }.should change(HierarchyNotification, :count).by(1)
        end
      end

      context "if notification doesn't exist and not well formated" do
        it "should responds within code 400 Bad request" do
          @params_error = { :hierarchy_notification => { :subject_id => 1 },
                            :format => :json }
          post :create, @params_error
          response.code.should == "400"
        end
      end
    end

    context "when not authorized" do
      it "should not create a hierarchy notification" do
        expect {
          post :create, @params
        }.should_not change(HierarchyNotification, :count)
      end

      it "should responds within code 401 Unathourized" do
        post :create, @params
        response.code.should == "401"
      end

    end
  end
end
