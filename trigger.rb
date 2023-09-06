require "mail"
require "bunny"
require "json"

require "./config/worker-queue"
require "./config/mail-server"


begin
  Rabbitmq[:queues][:emails].subscribe(block: true, manual_ack: true) do |delivery_info, _properties, body|

      props = JSON.parse(body)

      puts props

      Mail.deliver do
          header["Content-Type"] = "text/html"
          from     "medtempo2023@gmail.com"
          to       "#{props["to"]}"
          subject  "#{props["for"]}"
          body "Lorem Ipsum"
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