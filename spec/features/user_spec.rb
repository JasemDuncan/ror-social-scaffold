require 'rails_helper'

RSpec.describe 'Testing Friendship features', type: :feature, feature: true do
  context 'context' do
    before do
      @hans = User.create(email: 'hans@gmail.com', name: 'hans', password: '123456')
      @yaser = User.create(email: 'yaser@gmail.com', name: 'yaser', password: '123456')
      visit 'http://localhost:3000/users/sign_in'
      fill_in 'Email', with: 'hans@gmail.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'
    end
    scenario 'Test if the user hans@gmail.com can log in' do
      expect(page).to have_content('Signed in successfully.')
    end
    scenario 'Create a friend request, Yaser invites Hans, check if a Pending request exist' do
      url = 'http://localhost:3000/users/'
      url.concat(@yaser.id.to_s, '/friendships')
      page.driver.submit :post, url, {}
      expect(page).to have_content('Pending request')
      expect(@hans.pending_friends).to include @yaser
    end
    scenario 'Friend accept, Yaser invites Hans, Hans accepts the invitation' do
      # request
      url = 'http://localhost:3000/users/'
      url.concat(@yaser.id.to_s, '/friendships')
      page.driver.submit :post, url, {}
      expect(@hans.pending_friends).to include @yaser
      click_on 'Sign out'
      # Accept
      visit 'http://localhost:3000/users/sign_in'
      fill_in 'Email', with: 'yaser@gmail.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'
      visit 'http://localhost:3000/users'
      url = 'http://localhost:3000/friendships/'
      url.concat(@hans.id.to_s)
      page.driver.submit :patch, url, {}
      expect(page).to have_content('You accept an Invitation')
    end
    scenario 'Friend reject, Yaser invites, Hans rejects the invitation' do
      # request
      url = 'http://localhost:3000/users/'
      url.concat(@yaser.id.to_s, '/friendships')
      page.driver.submit :post, url, {}
      expect(@hans.pending_friends).to include @yaser
      # Reject
      click_on 'Sign out'
      visit 'http://localhost:3000/users/sign_in'
      fill_in 'Email', with: 'yaser@gmail.com'
      fill_in 'Password', with: '123456'
      click_on 'Log in'
      visit 'http://localhost:3000/users'
      url = 'http://localhost:3000/friendships/'
      url.concat(@hans.id.to_s)
      page.driver.submit :delete, url, {}
      expect(page).to have_content('You reject an Invitation')
    end
  end
end
