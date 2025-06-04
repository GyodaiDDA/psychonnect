# Methods to standartize all success and error responses
module ApiResponse
  def render_api_success(key, data: nil, status: :ok, locale: I18n.locale)
    message = I18n.t("api.success.#{key}", locale: locale, default: 'Success')
    response = { message: message }
    response[:data] = data if data.present?
    render json: response, status: status
  end

  def render_api_error(key, errors: nil, item: nil, status: :unprocessable_entity, locale: I18n.locale)
    message = I18n.t("api.error.#{key}", item: item || 'item', locale: locale, default: 'An error occurred')
    response = { error: message }
    response[:item] = item if item.present?
    response[:details] = format_errors(errors) if errors.present?
    render json: response, status: status
  end

  private

  def format_errors(errors)
    if errors.is_a?(ActiveModel::Errors)
      errors.full_messages
    elsif errors.respond_to?(:to_hash)
      errors.to_hash
    else
      Array.wrap(errors)
    end
  end
end
