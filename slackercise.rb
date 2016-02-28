require 'faye/websocket'
require 'eventmachine'
require 'net/http'
require 'json'
require 'pp'
ACCESS_TOKEN = 'redacted'
BOT_TOKEN = 'xoxb-23391667344-Ssy8BrhqKI3cT9D3jnyKabyf'
SLACK_ENV = ''

$data = {
  "rtm.start" => {
  },
  # "chat.postMessage" => {
  #   :channel => channel,
  #   :text => "Hi",
  #   :as_user => false,
  #   :username => 'Flack'
  # },
  # "chat.delete" => {
  #   :channel => channel,
  #   :ts => timestamp
  # },
  # "chat.update" => {
  #   :channel => channel,
  #   :ts => timestamp,
  #   :text => "New text"
  # },
  # "channels.list" => {
  # },
  # "channels.info" => {
  #   :channel => channel
  # },
  # "im.list" => {
  # },
  # "files.upload" => {
  #   :content => "This is the file",
  #   :filename => "title.txt",
  #   :title => "Title"
  # },
  # "mpim.list" => {
  # },
  # "pins.add" => {
  #   :name => "heart",
  #   :channel => channel,
  #   :timestamp => timestamp
  # },
  # "pins.remove" => {
  #   :name => "heart",
  #   :channel => channel,
  #   :timestamp => timestamp
  # },
  # "reactions.add" => {
  #   :name => "heart",
  #   :channel => channel,
  #   :timestamp => timestamp
  # },
  # "reactions.remove" => {
  #   :name => "heart",
  #   :channel => channel,
  #   :timestamp => timestamp
  # },
  # "stars.add" => {
  #   :name => "heart",
  #   :channel => channel,
  #   :timestamp => timestamp
  # },
  # "stars.remove" => {
  #   :name => "heart",
  #   :channel => channel,
  #   :timestamp => timestamp
  # },
  # "users.list" => {
  #   :presense => 1
  # },
  # "users.info" => {
  #   :user => user
  # },
  # "apps.list" => {
  # },
  # "apps.info" => {
  # }
}
def call(method, args={})
  params = $data[method].merge!(:token => BOT_TOKEN)
  params = params.merge!(args)
  url = "https://" + SLACK_ENV + "slack.com/api/" + method + build_query(params)
  puts url
  resp = Net::HTTP.get(URI.parse(url))
end
def build_query(hash)
  q = '?'
  hash.each do |k, v|
    q += k.to_s + "=" + v.to_s + "&"
  end
  q
end
res = call('rtm.start')
res = JSON.parse(res)
# pp res
EM.run {
  ws = Faye::WebSocket::Client.new(res['url'])
  ws.on :open do |event|
    p [:open]
  end
  ws.on :message do |event|
    p :message
    res = JSON.parse(event.data)
    p res
    if res['type'] == 'message'
      if res['text'] == 'help'
        msg = {
          :id => 1,
          :type => 'message',
          :channel => res['channel'],
          :text => 'What do you need help on?'
        }
        ws.send(msg.to_json)
      end
    end
  end
  ws.on :close do |event|
    p [:close, event.code, event.reason]
    ws = nil
  end
}