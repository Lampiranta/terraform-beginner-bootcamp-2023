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
import {
	"fmt"
	"github.com/hashicorp/terraform-plugin-sdk/v2/plugin"
}



// Entry point of application
func main() {
	plugin.Serve(&plugin.ServeOpts{
		ProviderFunc: Provider
	})
}

func Provider() *schema.provider {
	var p *schema.Provider
	p = &schema.Provider{
		ResourceMap:
		DataSourcesMap:
	}
}