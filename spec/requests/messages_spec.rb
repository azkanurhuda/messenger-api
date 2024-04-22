require 'rails_helper'

RSpec.describe 'Messages API', type: :request do
  let(:agus) { create(:user) }
  let(:dimas) { create(:user) }
  let(:dimas_headers) { valid_headers(dimas.id) }

  let(:samid) { create(:user) }
  let(:samid_headers) { valid_headers(samid.id) }

  # TODO: create conversation between Dimas and Agus, then set convo_id variable
  let(:convo) { create(:conversation)}
  let!(:conv_user1) { create(:conversation_user, :with_ids, conversation_id: convo.id, user_id: agus.id)}
  let!(:conv_user2) { create(:conversation_user, :with_ids, conversation_id: convo.id, user_id: dimas.id)}
  let!(:message) { create(:chat, :with_attrs, conversation_id: convo.id, sender_id: dimas.id, message: "Hi" )}

  describe 'get list of messages' do
    context 'when user have conversation with other user' do
      before { get "/conversations/#{convo.id}/messages", params: {}, headers: dimas_headers }

      it 'returns list all messages in conversation' do
        expect_response(
          :ok,
          data: [
            {
              id: Integer,
              message: String,
              sender: {
                id: Integer,
                name: String
              },
              sent_at: String
            }
          ]
        )
      end
    end

    context 'when user try to access conversation not belong to him' do
      # TODO: create conversation and set convo_id variable
      let(:convo1) { create(:conversation)}
      before { get "/conversations/#{convo1.id}/messages", params: {}, headers: samid_headers }

      it 'returns error 403' do
        expect(response).to have_http_status(403)
      end
    end

    context 'when user try to access invalid conversation' do
      # TODO: create conversation and set convo_id variable
      before { get "/conversations/-11/messages", params: {}, headers: samid_headers }

      it 'returns error 404' do
        expect(response).to have_http_status(404)
      end
    end
  end

  describe 'send message' do
    let(:valid_attributes) do
      { message: 'Hi there!', user_id: agus.id }
    end

    let(:invalid_attributes) do
      { message: '', user_id: agus.id }
    end

    context 'when request attributes are valid' do
      before { post "/messages", params: valid_attributes.to_json, headers: dimas_headers}

      it 'returns status code 201 (created) and create conversation automatically' do
        expect_response(
          :created,
          data: {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String
            },
            sent_at: String,
            conversation: {
              id: Integer,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String
              }
            }
          }
        )
      end
    end

    context 'when create message into existing conversation' do
      before { post "/messages", params: valid_attributes.to_json, headers: dimas_headers}

      it 'returns status code 201 (created) and create conversation automatically' do
        expect_response(
          :created,
          data: {
            id: Integer,
            message: String,
            sender: {
              id: Integer,
              name: String
            },
            sent_at: String,
            conversation: {
              id: convo.id,
              with_user: {
                id: Integer,
                name: String,
                photo_url: String
              }
            }
          }
        )
      end
    end

    context 'when an invalid request' do
      before { post "/messages", params: invalid_attributes.to_json, headers: dimas_headers}

      it 'returns status code 422' do
        expect(response).to have_http_status(422)
      end
    end
  end
end
