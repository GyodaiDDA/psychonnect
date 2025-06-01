# Methods to standartize all success and error responses
module ApiResponse
  def render_api_success(key, data: nil, status: :ok, locale: I18n.locale)
    message = I18n.t("api.success.#{key}", locale: locale)
    response = { message: message }
    response[:data] = data if data.present?
    render json: response, status: status
  end

  def render_api_error(key, errors: nil, status: :unprocessable_entity, locale: I18n.locale)
    message = I18n.t("api.error.#{key}", locale: locale)
    response = { error: message }
    response[:details] = errors if errors.present?
    render json: response, status: status
  end
end
