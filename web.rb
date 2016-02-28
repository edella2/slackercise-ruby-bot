require 'sinatra/base'

module SlackSlackercisebot
  class Web < Sinatra::Base
    get '/' do
      'Exercise is good for you.'
    end
  end
end