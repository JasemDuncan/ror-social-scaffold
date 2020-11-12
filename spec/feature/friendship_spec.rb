require 'rails_helper'
RSpec.describe 'Testing Friendship features', type: :feature, feature: true do
    context 'context' do
        before do
            @user = User.create(email: 'hans@gmail.com', name: 'hans', password: '123456')
            @user2 = User.create(email: 'yaser@gmail.com', name: 'yaser', password: '123456')
            visit 'http://localhost:3000/users/sign_in'
            fill_in 'Email', with: 'hans@gmail.com'
            fill_in 'Password', with: '123456'
            click_on 'Log in'
            # puts @user.id
            # puts @user2.id
            # puts 'before'
        end

        scenario 'log_in valid' do
            expect(page).to have_content('Signed in successfully.')
        end

        scenario 'friend request' do
            # visit 'http://localhost:3000/users'
            url = 'http://localhost:3000/users/'
            url.concat(@user2.id.to_s,'/friendships')
            page.driver.submit :post, url, {}            
            expect(@user.pending_friends).to include (@user2)
            expect(page).to have_content('Pending request')
        end

        scenario 'friend accept' do
            # request  
            url = 'http://localhost:3000/users/'
            url.concat(@user2.id.to_s,'/friendships')
            page.driver.submit :post, url, {}            
            expect(@user.pending_friends).to include (@user2)
            click_on 'Sign out'    
            # Accept           
            visit 'http://localhost:3000/users/sign_in'
            fill_in 'Email', with: 'yaser@gmail.com'
            fill_in 'Password', with: '123456'
            click_on 'Log in'
            visit 'http://localhost:3000/users'
            url = 'http://localhost:3000/friendships/'
            url.concat(@user.id.to_s)
            page.driver.submit :patch, url, {}
            expect(page).to have_content('You accept an Invitation')
        end

        scenario 'friend reject' do 
            # visit 'http://localhost:3000/users'
            # request
            url = 'http://localhost:3000/users/'
            url.concat(@user2.id.to_s,'/friendships')
            page.driver.submit :post, url, {}            
            expect(@user.pending_friends).to include (@user2) 
            # Reject
            click_on 'Sign out'
            visit 'http://localhost:3000/users/sign_in'
            fill_in 'Email', with: 'yaser@gmail.com'
            fill_in 'Password', with: '123456'
            click_on 'Log in'
            visit 'http://localhost:3000/users'
            url = 'http://localhost:3000/friendships/'
            url.concat(@user.id.to_s)
            # puts url
            page.driver.submit :delete, url, {}
            expect(page).to have_content('You reject an Invitation')
        end         
    end
end

