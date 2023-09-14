module Services
  class UserService
    method = rpc(:find, UserRequest, UserList)

    method.method
    method.request_type
    method.response_type
  end
end
