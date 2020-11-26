require 'rails_helper'
require 'rails_helper_capybara'

RSpec.feature 'Comment', type: :feature do
  context 'context' do
    before do
      @yaser = User.create(email: 'yaser@gmail.com', name: 'Yaser', password: '123456')
      visit 'http://localhost:3000/users/sign_in'
      fill_in 'Email', with: 'yaser@gmail.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'
    end

    scenario 'Do a comment' do
      find(:xpath, '//form[@id="new_comment"][@action="/posts/1/comments"]//input[@id="comment_content"]').set('This a comment from Yaser')
      find(:xpath, '//form[@id="new_comment"][@action="/posts/1/comments"]').click_on('Comment')
      expect(page).to have_content('Comment was successfully created.')
    end
  end
end
