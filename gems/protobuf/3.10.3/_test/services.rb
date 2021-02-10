module Services
  class UserService
    rpc :find, UserRequest, UserList
  end
end
