package users_transport_http

type UsersHTTPHandler struct {
	usersService UsersService
}

type UsersService interface {
}

func NewUsersHTTPHAndler(usersService UsersService) *UsersHTTPHandler {
	return &UsersHTTPHandler{
		usersService: usersService,
	}
}
