require "mail"
require "bunny"
require "json"
require "securerandom"

require "./config/redis"
require "./config/worker-queue"
require "./config/mail-server"
require "./config/template-parse"


begin
  Rabbitmq[:queues][:emails].subscribe(block: true, manual_ack: true) do |delivery_info, _properties, body|

      props = JSON.parse(body)

      if props["for"] == "verification-code"
        verify_code = SecureRandom.random_number(99999).to_s.rjust(5, "0")
        @redis.set(props["to"], verify_code)
        @redis.expire(props["to"], (15 * 60))

        puts @redis.get(props["to"])
        rendered = @templates["verification-code"].render({ "vcode" => verify_code, "person" => props["name"] }, { strict_variables: true })
        puts rendered
      end

      puts props

      Mail.deliver do
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