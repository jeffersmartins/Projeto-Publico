package main

import (
	"fmt"
	"time"

	submod "github.com/jeffersmartins/Submodulo-Privado"
)

func main() {
	user := submod.User{
		ID:        1,
		Name:      "Jefão",
		Email:     "jefao@teste.com",
		CreatedAt: time.Now(),
	}

	fmt.Printf("Usuário: %+v\n", user)
}
