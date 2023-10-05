// a package is a collection of related code 
// files that serve as a unit of organization 
// and code reuse. Packages help in structuring
// and modularizing Go programs, providing 
// encapsulation and managing code complexity.
package main

// The import statement is used to include 
// packages in a Go source file, making their 
// functions and types accessible for use 
// in the current program or package.
// fmt is short for format, contains functions for formatted I/O
import (
	// "log"
	"fmt"
	"github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
)



// Entry point of application
func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider,
	})
	// Format.PrintLine
	// Prints to standard output
	fmt.Println("Hello, world!")
}

// in golang, a titlecase function will get exported
func Provider() *schema.Provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourcesMap: map[string]*schema.Resource{

		},
		DataSourcesMap: map[string]*schema.Resource{

		},
		Schema: map[string]*schema.Schema{
			"endpoint": {
				Type: schema.TypeString,
				Required: true,
				Description: "The endpoint for the external service",
			},
			"token": {
				Type: schema.TypeString,
				Sensitive: true, // make the token as sensitive to hide it the logs
				Required: true,
				Description: "Bearer token for authorization",
			},
			"user_uuid": {
				Type: schema.TypeString,
				Required: true,
				Description: "UUID for configuration",
				//ValidateFunc: validateUUID,
			},
		},
	}
	//p.ConfigureContextFunc = providerConfigure(p)
	return p
}

//func validateUUID(v interface{}, k string) (ws []string, errors []error) {
//	log.Print("validateUUID:start")
//	value := v.(string)
//	if _, err := uuid.Parse(value); err != nil {
//		errors = append(errors, fmt.Errorf("invalid UUID format"))
//	}
//	log.Print("validateUUID:end")
//	return
//}
