module UsersHelper
  def user_friend(user)
    if current_user.friend?(user)
      'Connected'
    else
      user_friend_request(user)
    end
  end

  def user_friend_request(user)
    if current_user.friend_requests.include?(user)
      options = '<label class= "profile-link">'
      options.concat((link_to 'Accept', friendship_path(user), method: :patch))
      options.concat('</label>')
      options.concat('|')
      options.concat('<label class= "profile-link">')
      options.concat((link_to 'Cancel', friendship_path(user), method: :delete))
      options.concat('</label>')
      options.html_safe
    else
      pending_request(user)
    end
  end

  def pending_request(user)
    if current_user.pending_friends.include?(user)
      'Pending request'
    else
      button_to '**Add**', user_friendships_path(user.id), method: :post, class: 'profile-button'
    end
  end
end
