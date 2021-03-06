# If defined, ALAVETELI_TEST_THEME will be loaded in config/initializers/theme_loader
ALAVETELI_TEST_THEME = 'whatdotheyknow-theme'
require File.expand_path(File.join(File.dirname(__FILE__),'..','..','..','..','spec','spec_helper'))

describe UserInfoRequestSentAlert, "when patched by the whatdotheyknow-theme" do

  it 'should allow an alert type of "survey_1"' do
    info_request_sent_alert = UserInfoRequestSentAlert.new(:alert_type => 'survey_1')
    expect(info_request_sent_alert).to be_valid
  end

  it 'should send survey alerts when SEND_SURVEY_MAILS is set' do
      allow(AlaveteliConfiguration).to receive(:send_survey_mails).and_return(true)
      expect(RequestMailer).to receive(:alert_survey)
      RequestMailer.alert_new_response_reminders
  end

  it 'should not send survey alerts when SEND_SURVEY_MAILS is not set' do
      allow(AlaveteliConfiguration).to receive(:send_survey_mails).and_return(false)
      expect(RequestMailer).not_to receive(:alert_survey)
      RequestMailer.alert_new_response_reminders
  end

end

describe InfoRequest, "when creating an email subject for a request" do

    it 'should create a standard request subject' do
        info_request = FactoryGirl.build(:info_request)
        expect(info_request.email_subject_request)
          .to eq("Freedom of Information request - #{info_request.title}")
    end

    it 'should create a special request subject for requests to the General Register Office' do
        info_request = FactoryGirl.build(:info_request)
        allow(info_request.public_body).to receive(:url_name).and_return('general_register_office')
        expect(info_request.email_subject_request)
          .to eq("Freedom of Information request GQ - #{info_request.title}")
    end

    it 'should be able to create an email subject request for a batch request template without
        a public body' do
        info_request = FactoryGirl.build(:info_request)
        info_request.public_body = nil
        info_request.is_batch_request_template = true
        expect(info_request.email_subject_request)
          .to eq("Freedom of Information request - #{info_request.title}")
    end

end
