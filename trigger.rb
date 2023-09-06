require "mail"
require "bunny"
require "json"
require "securerandom"

require "./config/worker-queue"
require "./config/mail-server"
require "./config/template-parse"


begin
  Rabbitmq[:queues][:emails].subscribe(block: true, manual_ack: true) do |delivery_info, _properties, body|

      props = JSON.parse(body)

      if props["for"] == "verification-code"
        verify_code = SecureRandom.alphanumeric
        rendered = @templates["verification-code"].render({ "vcode" => verify_code, "person" => props["name"] }, { strict_variables: true })
        puts rendered
      end

      puts props

      Mail.deliver do
#          header["Content-Type"] = "text/html"
          from     "medtempo2023@gmail.com"
          to       "#{props["to"]}"
          subject  "#{props["for"]}"
          content_type "text/html; charset=UTF-8"
          body rendered
      end        

      Rabbitmq[:channel].ack(delivery_info.delivery_tag)

      puts "done"
  end

rescue Interrupt => _
    Rabbitmq[:connection].close
    exit(0)
rescue => error
  retry
end

Rabbitmq[:connection].close