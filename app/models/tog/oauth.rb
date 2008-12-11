# Tog::Oauth provides a simple way to create a consumer for an oauth provider.

module Oauth

  # This method uses Tog::Plugins settings to autoconfigure an oauth consumer for a given service. 
  # So if you want to request info from fireeagle you will have to set at least the following info:
  #
  # Tog::Plugins.settings :tog_social, "oauth.fireeagle.key"    => "OAUTH_KEY_HERE",
  #                                    "oauth.fireeagle.secret" => "OAUTH_SECRET_HERE",
  #                                    "oauth.fireeagle.site"   => "https://fireeagle.yahooapis.com",
  # ==== Attributes
  #
  # * <tt>:service</tt> - The service you want to use this consumer for.
  #
  def self.consumer(service)
    
    key = setting_for_service(service, "key")
    secret = setting_for_service(service, "secret")
    site = setting_for_service(service, "site")
    
    OAuth::Consumer.new(key, secret, {:site=>site})
  end
  
  protected
  
  def self.setting_for_service(service, setting)
    setting_key = "oauth.#{service}.#{setting}"
    value = Tog::Plugins.settings(:tog_social, setting_key)
    RAILS_DEFAULT_LOGGER.warn <<-WARNING

    **************************************************************************************************************************************************
    OAUTH WARNING: #{setting_key} setting is nil and this could potentially create problem in the oauth process.
    **************************************************************************************************************************************************

    WARNING
    ) unless value
    value
  end
  
end