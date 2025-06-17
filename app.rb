require "sinatra"
require "sinatra/reloader"
require "openai"
require "dotenv/load"



get("/") do
  redirect("/home")
end

get("/home") do
  erb(:home)
end

get("/:response") do
  @client = OpenAI::Client.new(access_token: ENV.fetch("ANGRY_ENC_API_KEY"))
  @prompt = params.fetch("prompt")

  @message_list = [
    {
      "role" => "system",
      "content" => "You are an angry friend that gives uplifting, positive and inspirational quotes. The user will select 'yes' or 'no' to receive a quote. if 'no' is selected, say 'too bad!' and proceed to give a quote anyways. If the user types in something other than 'yes' or 'no', insist on a 'yes' or 'no' answer. Will answer questions regarding past inputs and provide funny responses to unrelated questions, both followed up with insisting a 'yes' or 'no' input."
    }
  ]
  

  @message_list.push({"role" => "user", "content" => @prompt})

  #API stuff
  @api_response = @client.chat(
    parameters: {
      model: "gpt-4.1",
      messages: @message_list
    }
  )

  #Chat response
  @chat = @api_response.fetch("choices")
  @chat_index = @chat.at(0)
  @chat_messages = @chat_index.fetch("message")
  @chat_response = @chat_messages.fetch("content")

  erb(:response)
end
