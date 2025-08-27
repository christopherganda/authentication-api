module UserFinder
  extend ActiveSupport::Concern

  included do
    before_action :set_user, if: :requires_user_finder?
  end

  private
  def requires_user_finder?
    false
  end

  def set_user
    @user = User.find_by_id(params[:actor])
    unless @user
      render_error(:not_found, I18n.t('errors.messages.record_not_found', record: 'Actor'))
    end
  end
end
