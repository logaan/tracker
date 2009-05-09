
class Peer
  include DataMapper::Resource

  property :id,         Serial
  property :info_hash,  String
  property :peer_id,    String
  property :port,       Integer
  property :uploaded,   Integer
  property :downloaded, Integer
  property :left,       Integer
  property :ip,         String

  def bencode
    { "peer id" => self.peer_id, "ip" => self.ip, "port" => self.port }.bencode
  end
end

