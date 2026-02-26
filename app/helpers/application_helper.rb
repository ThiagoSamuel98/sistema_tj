module ApplicationHelper
  def current_user_name
    if controller.respond_to?(:current_user)
      controller.current_user&.name&.capitalize || 'Convidado'
    else
      'Convidado'
    end
  end
end
