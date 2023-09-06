puts "Bunny: #{ENV["RMQ_HOST"]}"

puts "Starting Bunny (Rabbitmq driver) ..."

Rabbitmq = Hash.new

Rabbitmq[:connection] = Bunny.new hostname: ENV["RMQ_HOST"], port: ENV["RMQ_PORT"].to_i, virtual_host: ENV["RMQ_VHOST"], username: ENV["RMQ_USR"], password: ENV["RMQ_PASS"]
Rabbitmq[:instance] = Rabbitmq[:connection].start               
Rabbitmq[:channel] = Rabbitmq[:instance].create_channel

Rabbitmq[:queues] = {
    :emails => Rabbitmq[:channel].queue("emails", durable: true)
}

puts "Rabbitmq connection established"
