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
        end

        scenario 'log_in valid' do
            expect(page).to have_content('Signed in successfully.')
        end

        scenario 'friend request' do
            visit 'http://localhost:3000/users'
            url = 'http://localhost:3000/users/'
            url.concat(@user2.id.to_s,'/friendships')
            page.driver.submit :post, url, {}            
            expect(@user.pending_friends).to include (@user2)
            expect(page).to have_content('Pending request')
        end

        scenario 'friend accept' do
            visit 'http://localhost:3000/users'
            url = 'http://localhost:3000/friendships/'
            url.concat(@user2.id.to_s)
            visit url
            click_on 'Sign out'
            visit 'http://localhost:3000/users/sign_in'
            fill_in 'Email', with: 'yaser@gmail.com'
            fill_in 'Password', with: '123456'
            click_on 'Log in'
            visit 'http://localhost:3000/users'
            url = 'http://localhost:3000/friendships/'
            url.concat(@user.id.to_s)
            page.driver.submit :patch, url, {}
            expect(page).to have_content('Accepted Friendship')
        end

        scenario 'friend reject' do 
            visit 'http://localhost:3000/users'
            url = 'http://localhost:3000/friendships/'
            url.concat(@user2.id.to_s)
            visit url
            click_on 'Sign out'
            visit 'http://localhost:3000/users/sign_in'
            fill_in 'Email', with: 'yaser@gmail.com'
            fill_in 'Password', with: '123456'
            click_on 'Log in'
            visit 'http://localhost:3000/users'
            url = 'http://localhost:3000/friendships/'
            url.concat(@user.id.to_s)
            page.driver.submit :delete, url, {}
            expect(page).to have_content('Rejected Friendship')
        end         
    end
end



# describe Calculator do
#     describe "#add" do
#         it "returns the sum of two numbers" do
#             #calculator = Calculator.new
#             expect(5+2).to eql(7)
#         end
#     end
# end