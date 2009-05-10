[
  "rubygems",
  "sinatra", "datamapper", "bencode", "peer", "db_config",
  "pp", "ruby-debug"
].each{ |requirement| require requirement }

# ToDo: Correctly return comple and incomplete values
# ToDo: Add failure handling and return failure reason
get "/announce" do
  # content_type "text/plain"
  case params[:event]
    when "started"    then started
    when "stopped"    then stopped
    when "completed"  then completed
    when nil          then regular
    else invalid_event_response
  end
end

# ToDo: Find out about corrupt, compact and key values sent by transmission
def started
  Peer.create :info_hash  => params[:info_hash],
              :peer_id    => params[:peer_id],
              :port       => params[:port],
              :uploaded   => params[:uploaded],
              :downloaded => params[:downloaded],
              :left       => params[:left],
              :ip         => (params[:ip] || "")
  peer_list_response
end

def stopped
  peer = Peer.first :info_hash  => params[:info_hash],
                    :peer_id    => params[:peer_id]
  peer.destroy
  peer_list_response
end

def completed
  peer_list_response
end

def regular
  peer_list_response
end

def peers(numwant)
  numwant = 30 if numwant == 0
  Peer.all(:limit => numwant).to_a
end

def peer_list_response
  response = {
    "interval"        => 60,
    "peers"           => peers(params[:numwant].to_i)
  }.bencode
end

def invalid_event_response
  {"failure reason" => "Invalid Event"}.bencode
end
