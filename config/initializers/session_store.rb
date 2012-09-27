# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_RockPaperScissors_session',
  :secret      => '019411c2104703e7303b207497d98a546dfde4b8ed1d327eb05027274910e48b4cb71ae789eecc625e79576da5d00f2857447bafef4b05743a71f1069e5bbf99'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
