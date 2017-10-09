class Spid::SingleSignOnsController < SpidController
  skip_before_action :verify_authenticity_token, only: :create

  def new
    request = OneLogin::RubySaml::Authrequest.new
    output = request.create(saml_settings)
    redirect_to output
  end

  def create
    response = OneLogin::RubySaml::Response.new(params[:SAMLResponse],
                                                skip_subject_confirmation: true)
    response.settings = saml_settings

    if response.is_valid?
      session[:index] = response.sessionindex
      redirect_to welcome_path, notice: 'Utente correttamente loggato'
    else
      render plain: response.inspect
    end
  end

end
