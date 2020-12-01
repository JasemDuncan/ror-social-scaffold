require 'rails_helper'
# require 'rails_helper_capybara'
# Capybara.default_driver = :selenium_chrome

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
      fill_in 'post_content', with: 'This is Hans post'
      click_on 'Save'
      a = '//a[@href="/posts/'
      post_id = Post.last.id.to_s
      c = '/likes"]'
      puts post_link = a + post_id + c
      find(:xpath, post_link).click
      expect(page).to have_content('You liked a post.')
    end
  end
end
