require 'dragonfly'

# Configure
Dragonfly.app.configure do
  plugin :imagemagick

  secret '4f26b765cba20111c3690221bdb6c3949a76cb5e329c0465d55951009e35851c'

  url_format '/media/:job/:name'

  datastore :file,
            root_path:   Rails.root.join('public/system/dragonfly', Rails.env),
            server_root: Rails.root.join('public')
end

# Logger
Dragonfly.logger = Rails.logger

# Mount as middleware
Rails.application.middleware.use Dragonfly::Middleware

# Add model functionality
if defined?(ActiveRecord::Base)
  ActiveRecord::Base.extend Dragonfly::Model
  ActiveRecord::Base.extend Dragonfly::Model::Validations
end
