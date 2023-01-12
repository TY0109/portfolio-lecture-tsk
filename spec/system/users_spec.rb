require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe 'Login処理' do
    before do
      Rails.application.env_config["devise.mapping"] = Devise.mappings[:user]
      Rails.application.env_config["omniauth.auth"] = OmniAuth.config.mock_auth[:line]
    end
    context 'LINEログインボタンを押した場合' do
      it 'ログインができる' do
        visit new_user_session_path
        click_on  'LINEログイン'
        expect(page).to have_current_path "https://276c-119-228-248-115.jp.ngrok.io/", ignore_query: true
        expect(page).to have_text 'ログインしました'
      end
    end
  end
end
