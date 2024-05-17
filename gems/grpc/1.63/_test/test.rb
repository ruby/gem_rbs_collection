require "grpc"

begin
  raise GRPC::Unavailable
rescue GRPC::BadStatus => e
  # nop
end
