class SessionsController < Devise::SessionsController
	layout 'application'

	def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
