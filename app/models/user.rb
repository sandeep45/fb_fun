class User < ActiveRecord::Base
	has_one :facebook
	has_many :emails
end
