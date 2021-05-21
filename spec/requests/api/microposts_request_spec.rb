require 'rails_helper'

RSpec.describe "Api::Microposts", type: :request do
  describe 'GET /api/microposts' do
    let!(:microposts) { create_list(:micropost, 5) }
    it 'マイクロポストの一覧が取得できること' do
      get api_microposts_path
      expect(response).to have_http_status(200)
      json = JSON.parse(response.body)
      expect(json['microposts']).to match_array(microposts.map { |micropost|
        include(
            'id' => micropost.id,
            'content' => micropost.content,
            'user' => include('id' => micropost.user.id)
        )
      })
    end
  end

  describe 'POST /api/microposts' do
    let(:user) { create(:user) }
    let(:token) { Jwt::TokenProvider.call(user_id: user.id) }
    let(:headers) { { Authorization: "Bearer #{token}"} }
    let(:micropost_params) { { micropost: { content: 'hoge' } } }
    context 'ログイン済みの場合' do
      it 'ユーザーが作成できること' do
        post api_microposts_path, params: micropost_params, headers: headers
        expect(response).to have_http_status(201)
        json = JSON.parse(response.body)
        expect(json['micropost']).to include({
                                                 'id' => be_present,
                                                 'content' => 'hoge',
                                                 'user' => include('id' => user.id)
                                             })
      end
    end

    context 'ログインしていない場合' do
      it '401エラーになること' do
        post api_microposts_path, params: micropost_params
        expect(response).to have_http_status(401)
        json = JSON.parse(response.body)
        expect(json['error']).to include({
                                             'messages' => be_present
                                         })
      end
    end
  end

  describe 'PATCH /api/microposts/:id' do
    let(:user) { create(:user) }
    let(:token) { Jwt::TokenProvider.call(user_id: user.id) }
    let(:headers) { { Authorization: "Bearer #{token}"} }
    let(:micropost) { create(:micropost, user: user) }
    let(:micropost_params) { { micropost: { content: 'hoge' } } }
    context 'ログイン済みの場合' do
      it 'マイクロポストが更新できること' do
        patch api_micropost_path(micropost), params: micropost_params, headers: headers
        expect(response).to have_http_status(200)
        json = JSON.parse(response.body)
        expect(json['micropost']).to include({
                                                 'id' => be_present,
                                                 'content' => 'hoge',
                                                 'user' => include('id' => user.id)
                                             })
      end
    end

    context 'ログインしていない場合' do
      it '401エラーになること' do
        patch api_micropost_path(micropost), params: micropost_params
        expect(response).to have_http_status(401)
        json = JSON.parse(response.body)
        expect(json['error']).to include({
                                             'messages' => be_present
                                         })
      end
    end
  end

  describe 'POST /api/microposts' do
    let(:user) { create(:user) }
    let(:token) { Jwt::TokenProvider.call(user_id: user.id) }
    let(:headers) { { Authorization: "Bearer #{token}"} }
    let(:micropost_params) { { micropost: { content: 'hoge' } } }
    context 'ログイン済みの場合' do
      it 'ユーザーが作成できること' do
        post api_microposts_path, params: micropost_params, headers: headers
        expect(response).to have_http_status(201)
        json = JSON.parse(response.body)
        expect(json['micropost']).to include({
                                                 'id' => be_present,
                                                 'content' => 'hoge',
                                                 'user' => include('id' => user.id)
                                             })
      end
    end

    context 'ログインしていない場合' do
      it '401エラーになること' do
        post api_microposts_path, params: micropost_params
        expect(response).to have_http_status(401)
        json = JSON.parse(response.body)
        expect(json['error']).to include({
                                             'messages' => be_present
                                         })
      end
    end
  end
end