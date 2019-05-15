# API Specifications

Provides Open API Specification 3 definitions for Nexmo APIs.

These definitions provide a single point of truth that can be used end-to-end:

- **Planning** Shared during product discussions for planning API functionality
- **Implementation** Inform engineering during development
- **Testing** As the basis for testing or mocking API endpoints
- **Documentation** For producing thorough and interactive documentation
- **Tooling** To generate server stubs and client SDKs.

## Definitions

| API | Definition owner | Contributors |
| --- | ---------------- | ------------ |
| SMS | - | Adam Butler |
| Voice | - | - |
| Verify | - | Adam Butler, Mike Ralphson |
| Number Insight | - | Adam Butler, Mike Ralphson |
| Conversation | Neil Stratford | Adam Butler |
| Olympus | Hugh Hopkins |
| Account | - | - |
| Messages | - | - |
| Messages | - | - |
| Numbers | - | - |
| Application | - | - |
| Conversion | - | - |

## Resources

- [What is OpenAPI?](https://swagger.io/docs/specification/about/)
- [A Visual Guide to What's New in Swagger 3.0](https://blog.readme.io/an-example-filled-guide-to-swagger-3-2/)
- [OAS3 Documentation](https://swagger.io/docs/specification/basic-structure/)
- [OAS3 Specification](https://github.com/OAI/OpenAPI-Specification/blob/master/versions/3.0.0.md)
- [OAS3 Examples](https://github.com/OAI/OpenAPI-Specification/tree/master/examples/v3.0)

## Tools

- [Swagger Editor](http://editor.swagger.io/) - Can be used to edit OAS3 definitions, provides live reloading Swagger UI.
- [Swagger 2.0 to OAS3 converter](https://openapi-converter.herokuapp.com/) - Unofficial converter that can be used to convert existing Swagger 2.0 definitions to OAS3 definitions.
- [Swagger Codegen](https://github.com/swagger-api/swagger-codegen) - A template-driven engine to generate documentation, API clients and server stubs in different languages by parsing OAS3 definitions.
- [Swagger Parser](https://github.com/swagger-api/swagger-parser) - Standalone library for parsing OAS3 definitions from Java
- [Nexmo Developer](https://github.com/Nexmo/nexmo-developer) - Nexmo Developer has its own OAS3 definition parser and API reference UI.

## Consuming

These API Specifications can be made available as packages. See below for the currently available packages and instructions on how to consume them.

### Ruby

##### Install the Gem

```sh
$ gem install nexmo_api_specification
```

or add it to your GemFile and run `bundle install`

```ruby
gem 'nexmo_api_specification'
```

##### Usage

Get a definition file:

```ruby
NexmoApiSpecification::Definition.load(:sms)
```

## Contributing

Contributions are welcome, please follow [GitHub Flow](https://guides.github.com/introduction/flow/index.html)


## Publishing

Clone the repo and navigate to its directory:

```sh
$ cd api-specification
```

Bump the latest version in `api-specification/lib/nexmo_api_specification/version.rb`:

```ruby
# old
module OasParser
  VERSION = '1.0.0'.freeze
end

# new
module OasParser
  VERSION = '1.1.0'.freeze
end
```

Build the gem:

```sh
$ gem build nexmo_api_specification.gemspec
```

_This will create a `nexmo_api_specification-1.1.0.gem` file._

Push the gem to rubygems.org:

```sh
$ gem push nexmo_api_specification-1.1.0.gem
```

Verify the change was made by checking for the [new version on rubygems.org](https://rubygems.org/gems/nexmo_api_specification)

Don't forget to commit and push your changes after increasing the version number!
