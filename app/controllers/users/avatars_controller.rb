class Users::AvatarsController < ApplicationController
  before_action :authenticate_user!

  def show
    user = User.find(params[:id])
    return head :not_found unless user.avatar?

    cache_headers

    if stale?(etag: avatar_etag(user), last_modified: avatar_last_modified(user), public: true)
      send_data user.avatar.read, type: avatar_content_type(user), disposition: 'inline'
    end
  end

  private

  def cache_headers
    response.headers['Cache-Control'] = 'public, max-age=31536000, immutable'
  end

  def avatar_etag(user)
    [user.id, user.avatar.identifier]
  end

  def avatar_last_modified(user)
    file = user.avatar.file
    return file.mtime if file.respond_to?(:mtime)
    return file.last_modified if file.respond_to?(:last_modified)

    user.updated_at
  end

  def avatar_content_type(user)
    file = user.avatar.file
    return file.content_type if file.respond_to?(:content_type) && file.content_type.present?

    user.avatar.content_type if user.avatar.respond_to?(:content_type)
  end
end
