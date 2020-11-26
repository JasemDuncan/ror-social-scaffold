require 'rails_helper'

RSpec.describe Friendship, type: :model do
  before do
    @yaser = User.create(email: 'yaser@mail.com', name: 'Yaser Alain', password: '123456')
    @hans = User.create(email: 'hans@mail.com', name: 'Hans Bill', password: '123456')
    @jan = User.create(email: 'jan@mail.com', name: 'Jan', password: '123456')
  end

  it 'Show relation of friends' do
    @yaser.request_friend(@hans)
    @hans.confirm_friend(@yaser)
    u = User.find(@yaser.id)
    expect(u.friend?(@hans)).to be true
  end

  it 'Show there is no relation of friends' do    
    u = User.find(@yaser.id)
    expect(u.friend?(@jan)).to be false
  end

  context 'Association' do
    it { expect(subject).to belong_to(:user) }
    
  end
end