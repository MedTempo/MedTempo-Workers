require "redis"

credentials = {
    :host => ENV["REDIS_HOST"],
    :port => ENV["REDIS_PORT"],
    :user => ENV["REDIS_USR"],
    :password => ENV["REDIS_PASS"]
}

@redis = Redis.new(host: credentials[:host], port: credentials[:port], username: credentials[:user], password: credentials[:password])
