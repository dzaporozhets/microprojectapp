class Users::AvatarsController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find(params[:id])
    return head :not_found unless user.avatar?

    cache_headers

    if stale?(etag: avatar_etag(user), last_modified: user.avatar.blob.created_at, public: true)
      send_data user.avatar.download, type: user.avatar.content_type, disposition: 'inline'
    end
  end

  private

  def cache_headers
    response.headers['Cache-Control'] = 'public, max-age=31536000, immutable'
  end

  def avatar_etag(user)
    [user.id, user.avatar.blob.checksum]
  end
end
