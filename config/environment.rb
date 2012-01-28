# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
MicroMax::Application.initialize!

Date::DATE_FORMATS[:default] = "%d %b %Y"
