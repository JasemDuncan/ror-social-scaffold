require 'rails_helper'
require 'rails_helper_capybara'

RSpec.feature 'Like', type: :feature do
  context 'context' do
    before do
      @yaser = User.create(email: 'yaser@mail.com', name: 'Yaser Alain', password: '123456')
      @hans = User.create(email: 'hans@mail.com', name: 'Hans Bill', password: '123456')
      visit 'http://localhost:3000/users/sign_in'
      fill_in 'Email', with: 'hans@gmail.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'
    end

    it 'show friends confirmed, Yaser invites Hans' do
      @yaser.request_friend(@hans)
      @hans.confirm_friend(@yaser)
      visit 'http://localhost:3000/users'
      expect(page).to have_content('Connected')
    end
  end
end
