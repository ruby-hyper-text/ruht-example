# frozen_string_literal: true

require 'date'
require 'sinatra'
require 'ruht'
require 'json'

set :public_folder, File.expand_path('../public', __dir__)

get '/' do
  current_time = Time.now

  time_component = lambda do |time_to_display|
    Ruht::Fragment.new do
      time datetime: time_to_display.iso8601 do
        time_to_display.asctime
        time_to_display.strftime('%d %B %Y %H:%M')
      end
    end
  end

  debug = {
    params: params,
    time_component: time_component.(Time.now),
    binding: {
      local_variables: binding.local_variables,
      params: binding.receiver.params,
      receiver: binding.receiver.class,
    },
    self: self.class
  }

  Ruht.html do
    doctype :html

    html lang: :en do
      head do
        meta charset: 'UTF-8'
        meta 'http-equiv': 'X-UA-Compatible', content: 'IE=edge'
        meta name: :viewport, content: 'width=device-width, initial-scale=1.0'
        title { 'Hello from RUHT!' }

        link rel: :stylesheet, href: 'styles.css'
        style do
          <<~CSS
            pre {
              font-family: monospace;
              font-weight: 500;
              border: 1px solid white;
            }
          CSS
        end
      end

      body do
        main do
          p { 'Hello from RUHT' }

          render! time_component.(current_time)

          pre do
            render! JSON.pretty_generate(debug)
          end

          p do
            (1..10).each do |i|
              span(id: i) { render! i.to_s }
            end
          end

          pre do
            binding.receiver.class.name
          end
        end
      end
    end
  end
end
