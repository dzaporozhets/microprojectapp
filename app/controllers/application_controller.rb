class ApplicationController < ActionController::Base
  def record_not_found
    render file: Rails.root.join("public", "404.html"), status: :not_found, layout: false
  end

  def authorize_access
    if current_user.has_access_to?(project)
      true
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
