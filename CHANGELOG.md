# 0.8.1
* Fix an issue where API docs were not being found

# 0.8.0
* Fix an issue when the description is `nil`
* Include nexmo-markdown-renderer
* Remove white box surrounding HTTP responses
* Allow multi-depth `oneOf` definitions
* Render endpoint's description as markdown

# 0.7.1
* Use schema's description when there isn't one at the parameter level

# 0.7.0
* Prevent sinatra from showing error traces, use custom 500 page instead
* Bump oas_parser to version 0.23.0. Ensures interoperability between JSON and YAML formats by forcing keys to be strings

# 0.6.6
* Make tabs clickable

# 0.6.5
* Fix rendering of different versions

# 0.6.4
* Render required tag for oneOf request bodies

# 0.6.3
* Remove the need to have a `definitions` folder, just specify the correct path in `OAS_PATH`
* Remove OAS constraints, since they are not needed to run this standalone

# 0.6.0
* Upgraded to Rails 6

# 0.5.6
* Add `reports` to open_api docs' constraints
* Make tab selection with `x-tab-id` trigger all tabs (support for request bodies)
* Remove CSS styling for tutorial links

# 0.5.5
* Add `vonage-business-cloud/reports` to open_api docs' constraints

# 0.1.0
* First version!
