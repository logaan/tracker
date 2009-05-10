[
  "rubygems",
  "sinatra", "datamapper", "bencode", "peer", "db_config",
  "pp", "ruby-debug"
].each{ |requirement| require requirement }

# ToDo: Correctly return comple and incomplete values
# ToDo: Add failure handling and return failure reason
get "/announce" do
  case params[:event]
    when "started"    then started
    when "stopped"    then stopped
    when "completed"  then completed
    when nil          then regular
    else "Invalid request"
  end

  response = {
    "interval"        => 60,
    "peers"           => peers(params[:numwant].to_i)
  }.bencode
  puts "=== RESPONSE ==="
  pp response
  return response
end

# ToDo: Find out about corrupt, compact and key values sent by transmission
def started
  puts "=== STARTED ==="
  peer = Peer.create  :info_hash  => params[:info_hash],
                      :peer_id    => params[:peer_id],
                      :port       => params[:port],
                      :uploaded   => params[:uploaded],
                      :downloaded => params[:downloaded],
                      :left       => params[:left],
                      :ip         => (params[:ip] || "")
end

def stopped
  puts "=== STOPPED ==="
  peer = Peer.first :info_hash  => params[:info_hash],
                    :peer_id    => params[:peer_id]
  peer.destroy
end

def completed
  puts "=== COMPLETED ==="
end

def regular
  puts "=== REGULAR ==="
end

def peers(numwant)
  numwant = 30 if numwant == 0
  Peer.all(:limit => numwant).to_a
end

