Mail.defaults do

  if ENV["IS_PROD"] == false
    delivery_method :test
  else
    delivery_method :smtp, { 
      address:              'smtp.gmail.com',
      port:                 587,
      domain:               'medtempo.com',
      user_name:            ENV["EMAIL_USR"],
      password:             ENV["EMAIL_PASS"],
      authentication:       'plain',
      enable_starttls_auto: true
    }
  end
end