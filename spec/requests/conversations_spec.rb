require 'rails_helper'

RSpec.describe 'Conversations API', type: :request do
  let(:dimas) { create(:user) }
  let(:dimas_headers) { valid_headers(dimas.id) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid.id) }

  describe 'GET /conversations' do
    context 'when user have no conversation' do
      # make HTTP get request before each example
      before { get '/conversations', params: {}, headers: dimas_headers }

      it 'returns empty data with 200 code' do
        expect_response(
          :ok,
          data: []
        )
      end
    end

    context 'when user have conversations' do
      # TODOS: Populate database with conversation of current user
      let!(:conv1) { create(:conversation)}
      let!(:conv2) { create(:conversation)}
      let!(:conv3) { create(:conversation)}
      let!(:conv4) { create(:conversation)}
      let!(:conv5) { create(:conversation)}
      let!(:cu1) { create(:conversation_user, :with_ids, user_id: dimas.id, conversation_id: conv1.id)}
      let!(:cu2) { create(:conversation_user, :with_ids, user_id: dimas.id, conversation_id: conv2.id)}
      let!(:cu3) { create(:conversation_user, :with_ids, user_id: dimas.id, conversation_id: conv3.id)}
      let!(:cu4) { create(:conversation_user, :with_ids, user_id: dimas.id, conversation_id: conv4.id)}
      let!(:cu5) { create(:conversation_user, :with_ids, user_id: dimas.id, conversation_id: conv5.id)}
      let!(:cu6) { create(:conversation_user, :with_ids, user_id: samid.id, conversation_id: conv1.id)}
      let!(:cu7) { create(:conversation_user, :with_ids, user_id: samid.id, conversation_id: conv2.id)}
      let!(:cu8) { create(:conversation_user, :with_ids, user_id: samid.id, conversation_id: conv3.id)}
      let!(:cu9) { create(:conversation_user, :with_ids, user_id: samid.id, conversation_id: conv4.id)}
      let!(:cu10) { create(:conversation_user, :with_ids, user_id: samid.id, conversation_id: conv5.id)}
      let!(:message1) { create(:chat, :with_attrs, conversation_id: conv1.id, sender_id: dimas.id, message: "Hi" )}
      let!(:message2) { create(:chat, :with_attrs, conversation_id: conv2.id, sender_id: dimas.id, message: "Hi" )}
      let!(:message3) { create(:chat, :with_attrs, conversation_id: conv3.id, sender_id: dimas.id, message: "Hi" )}
      let!(:message4) { create(:chat, :with_attrs, conversation_id: conv4.id, sender_id: dimas.id, message: "Hi" )}
      let!(:message5) { create(:chat, :with_attrs, conversation_id: conv5.id, sender_id: dimas.id, message: "Hi" )}
      before { get '/conversations', params: {}, headers: dimas_headers }

      it 'returns list conversations of current user' do
        # Note `response_data` is a custom helper
        # to get data from parsed JSON responses in spec/support/request_spec_helper.rb

        expect(response_data).not_to be_empty
        expect(response_data.size).to eq(5)
      end

      it 'returns status code 200 with correct response' do
        expect_response(
          :ok,
          data: [
            {
              id: Integer,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String
              },
              last_message: {
                id: Integer,
                sender: {
                  id: Integer,
                  name: String
                },
                message: String,
                sent_at: String
              },
              unread_count: Integer
            }
          ]
        )
      end
    end
  end

  describe 'GET /conversations/:id' do
    context 'when the record exists' do
      # TODO: create conversation of dimas
      let!(:conv) { create(:conversation)}
      let!(:cu1) { create(:conversation_user, :with_ids, user_id: dimas.id, conversation_id: conv.id)}
      let!(:cu2) { create(:conversation_user, :with_ids, user_id: samid.id, conversation_id: conv.id)}
      before { get "/conversations/#{conv.id}", params: {}, headers: dimas_headers }

      it 'returns conversation detail' do
        expect_response(
          :ok,
          data: {
            id: Integer,
            with_user: {
              id: Integer,
              name: String,
              photo_url: String
            }
          }
        )
      end
    end

    context 'when current user access other user conversation' do
      let!(:conv) { create(:conversation)}
      before { get "/conversations/#{conv.id}", params: {}, headers: samid_headers }

      it 'returns status code 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when the record does not exist' do
      before { get "/conversations/-11", params: {}, headers: dimas_headers }

      it 'returns status code 404' do
        expect(response).to have_http_status(404)
      end
    end
  end
end