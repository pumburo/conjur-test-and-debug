package main

import (
    "os"
    "fmt"
    "time"
    "github.com/cyberark/conjur-api-go/conjurapi"
)

func main() {
    secretUsername := os.Getenv("CONJUR_USERNAME_PATH")
    secretPassword := os.Getenv("CONJUR_PASSWORD_PATH")

    config, err := conjurapi.LoadConfig()
    if err != nil {
        panic(err)
    }
    fmt.Println("CONJUR_AUTHN_LOGIN:  ", os.Getenv("CONJUR_AUTHN_LOGIN"))
    fmt.Println("CONJUR_AUTHN_TOKEN_FILE:  ", os.Getenv("CONJUR_AUTHN_TOKEN_FILE"))
    authnTokenFile := os.Getenv("CONJUR_AUTHN_TOKEN_FILE")
    conjur, err := conjurapi.NewClientFromTokenFile(config,authnTokenFile)
    if err != nil {
        panic(err)
    }
    for true {
        secretUsernameValue, err := conjur.RetrieveSecret(secretUsername)
        secretPasswordValue, err := conjur.RetrieveSecret(secretPassword)
        
       if err != nil {
        panic(err)
       }
       fmt.Println("The username value is: ", string(secretUsernameValue))
       fmt.Println("The password value is: ", string(secretPasswordValue))

       secretUsernameResponse, err := conjur.RetrieveSecretReader(secretUsername)
       secretPasswordResponse, err := conjur.RetrieveSecretReader(secretPassword)
       if err != nil {
           panic(err)
       }

       secretUsernameValue, err = conjurapi.ReadResponseBody(secretUsernameResponse)
       secretPasswordValue, err = conjurapi.ReadResponseBody(secretPasswordResponse)
       if err != nil {
           panic(err)
       }
       fmt.Println("The secret value is: ", string(secretUsernameValue))
       fmt.Println("The password value is: ", string(secretPasswordValue))
       time.Sleep(10 * time.Second)
    }
}
