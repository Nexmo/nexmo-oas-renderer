# Nexmo OAS Renderer
Sinatra application that provides a preview of how the OAS documents will be rendered within [Nexmo Developer](https://developer.nexmo.com/).

* [Dependencies](#requirements)
* [Installation and Usage](#installation-and-usage)
    * [As a standalone application](#as-a-standalone-application)
    * [Mounted into a Rails application](#mounted-into-a-rails-application)
    * [Specifying the path to the documents](#specifying-the-path-to-the-documents)
* [Contributing](#contributing)
* [License](#license)

## Dependencies


## Installation and Usage

### As a standalone application

Install the gem:

``` shell
$ gem install nexmo-oas-renderer
```

And simply run the executable:
``` shell
$ nexmo-oas-renderer
```

### Mounted into a Rails Application

Add this to your application's `Gemfile`:

```
gem 'nexmo-oas-renderer', require: false
```

And then run `bundle install`.

Require the gem in `config/environment.rb` as follows:

``` ruby
# Load the Rails application.
require_relative 'application'

require 'nexmo/oas/renderer'

# Initialize the Rails application.
Rails.application.initialize!
```

And finally mount the Sinatra app into your Rails application by adding the following line to `config/routes.rb`:

``` ruby
mount Nexmo::OAS::Renderer::API, at: '/api'
```

### Specifying the path to the documents

This gem uses [dotenv](https://github.com/bkeepers/dotenv) to handle environment variables, so you should copy the `.env.example` provided by running:
``` shell
$ cp .env.example .env
```
and assign values to the corresponding variables.

#### Note
The app won't boot if the env variable `OAS_PATH` is not set. This variable indicates the path to the documents that will be rendered.

## Contributing
We ❤️ contributions from everyone! [Bug reports](https://github.com/Nexmo/nexmo-oas-renderer/issues), [bug fixes](https://github.com/Nexmo/nexmo-oas-renderer/pulls) and feedback on the library is always appreciated. Look at the [Contributor Guidelines](https://github.com/Nexmo/nexmo-oas-renderer/blob/master/CONTRIBUTING.md) for more information and please follow the [GitHub Flow](https://guides.github.com/introduction/flow/index.html).

## License
This project is under the [MIT LICENSE](https://github.com/Nexmo/nexmo-oas-renderer/blob/master/LICENSE).