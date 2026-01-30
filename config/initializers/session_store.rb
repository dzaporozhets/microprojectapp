# frozen_string_literal: true

Rails.application.config.session_store :cookie_store,
                                        key: '_microproject_session',
                                        expire_after: 1.week
