module SlackSlackercisebot
  module Commands
    class Exercise < SlackRubyBot::Commands::Base
      command 'ping' do |client, data, match|
	    	client.say(text: 'SLACKERCISE RULLLEEESSSS', channel: data.channel)
		  end


		  command 'addme' do |client, data, match|
		    user_data = client.users[data[:user]]

        # deploy on "http://slackercise.herokuapp.com/users"
		    HTTParty.post("http://localhost:3000/users",
		      body: {
		        user: {
		          team_id: user_data["team_id"],
		          name: user_data["name"],
		          real_name: user_data["real_name"],
		          first_name: user_data["profile"]["first_name"],
		          last_name: user_data["profile"]["last_name"],
		          image_original: user_data["profile"]["image_original"],
		          email: user_data["profile"]["email"] }
		        }.to_json,
		      headers: {'Content-Type' => 'application/json', 'Accept' => 'application/json'}
		      )
		  end
    end
  end
end


