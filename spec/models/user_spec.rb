require 'rails_helper'

RSpec.describe User, type: :model do
    context 'context' do
        before do
            @yaser = User.create(email: 'yaser@mail.com', name: 'Yaser Alain', password: '123456')
            @hans = User.create(email: 'hans@mail.com', name: 'Hans Bill', password: '123456')
        end

        it 'show friends confirmed, Yaser invites Hans' do
            @yaser.request_friend(@hans)
            @hans.confirm_friend(@yaser)
            u = User.find(@yaser.id)
            expect(u.friends.first.id).to be @hans.id
        end

        it 'show pending_friends, Yaser invites Hans, Yaser verified pending friends accept' do
            @yaser.request_friend(@hans)
            expect(@yaser.pending_friends.first.id).to be @hans.id
        end
        
        it 'show friend_request, Yaser invites Hans, Hans checks if there is some invitation' do
            @yaser.request_friend(@hans)
            expect(@hans.friend_requests.first.id).to be @yaser.id
        end
        
        it 'request_friend second time, Yaser invites Hans, Yaser cheks if he can invite again Hans'do
            @yaser.request_friend(@hans)
            expect(@yaser.request_friend(@hans)).to be false
        end

        it 'reject_friend request, Yaser invites Hans, Hans rejects Yaser, so Yaser has not friends' do
            @yaser.request_friend(@hans)
            @hans.reject_friend(@yaser)
            u=User.find(@yaser.id)
            expect(u.friends.first).to be nil
        end

        it 'Confirm friend, Yaser invites Hans, Hans accepts Yaser, Yaser checks if Hans is his friend' do
            @yaser.request_friend(@hans)
            @hans.confirm_friend(@yaser)
            u=User.find(@yaser.id)
            expect(u.friend?(@hans)).to be true
        end

        it 'friend yourself, yaser try to invite yaser' do
            expect(@yaser.relation_exist?(@yaser)).to be true
        end

    end
end