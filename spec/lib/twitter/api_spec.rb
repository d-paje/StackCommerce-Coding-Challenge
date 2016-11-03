require 'rails_helper'

describe Twitter::Api do
  describe '.timeline_for' do 
    it 'should return an error if the given user is not registered on Twitter' do
      VCR.use_cassette "no twitter account" do
        user = 'notarealpersonlololololol'
        results = Twitter::Api.timeline_for(user)

        expect(results.error).not_to be_nil
        expect(results.error).to eq("#{user} doesn't have a Twitter account :(")
      end
    end 

    it 'should return an error if Twitter returns error(s)' do
      body = {"errors":[{"message":"Invalid or expired token","code":89}]}
      stub_request(:get, /https:\/\/api.twitter.com\/1.1\//).
        to_return(status: 401, body: body.to_json)

      expect(Rails.logger).to receive(:error).with("TWITTER_ERR: status 401, code: 89, error: Invalid or expired token").and_call_original

      user = 'notarealpersonlololololol'
      results = Twitter::Api.timeline_for(user)

      expect(results.error).not_to be_nil
    end

    context 'famous tweeter' do
      before(:each) do
        @user = 'justinbieber'
      end

      it 'should return 25 tweets by default if the user has 25 or more tweets' do
        VCR.use_cassette "25 tweets" do
          results = Twitter::Api.timeline_for(@user)

          expect(results.error).to be_nil
          expect(results.data.count).to eq(25)
        end
      end

      it 'should return a specified number of tweets' do
        VCR.use_cassette "13 tweets" do
          results = Twitter::Api.timeline_for(@user, {count: 13})

          expect(results.error).to be_nil
          expect(results.data.count).to eq(13)
        end
      end
    end
  end

  describe '.search_for' do
    it "should search using twitter's search endpoint" do
      VCR.use_cassette "search for hello" do 
        results = Twitter::Api.search_for('hello')

        expect(results.error).to be_nil
        expect(results.data).not_to be_empty
      end
    end
  end
end
