class FriendshipsController < ApplicationController
  
    def create
        @friendship = current_user.friendship.build
        @friendship.friend_id = params[:user_id]
    
        if @friendship.save
          redirect_to users_path, notice: 'You send an invitation.'
        else
            redirect_to users_path, notice: 'You do not send an invitation.'
        end
      end


end