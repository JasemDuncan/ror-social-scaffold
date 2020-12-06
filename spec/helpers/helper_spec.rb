require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  let(:yaser) { User.create(name: 'Yaser', email: 'yaser@gmail.com', password: '123456') }
  let(:hans) { User.create(name: 'Hans', email: 'hans@gmail.com', password: '123456') }
  let(:post) { Post.create(content: 'This a Hans post', user_id: hans.id) }
  describe 'like' do
    it 'like a post' do
      expect(helper.like_or_dislike_btn(post)).to include('Like!')
    end
  end
end
