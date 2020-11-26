require 'rails_helper'
require 'rails_helper_capybara'

RSpec.feature 'Like', type: :feature do
  context 'context' do
    before do
      @hans = User.create(email: 'hans@gmail.com', name: 'Hans', password: '123456')
      visit 'http://localhost:3000/users/sign_in'
      fill_in 'Email', with: 'hans@gmail.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'
    end

    scenario 'Give like ' do
      find(:xpath, '//a[@href="/posts/1/likes"]').click
      expect(page).to have_content('You liked a post.')
    end
  end
  context 'context' do
    before do
      @hans = User.create(email: 'hans@gmail.com', name: 'Hans', password: '123456')
      visit 'http://localhost:3000/users/sign_in'
      fill_in 'Email', with: 'hans@gmail.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'
    end

    scenario 'Give Dislike ' do
      click_on 'Dislike!'
      expect(page).to have_content('You disliked a post.')
    end
  end
end
