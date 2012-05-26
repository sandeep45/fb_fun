class Facebook < ActiveRecord::Base
	belongs_to :user
	has_one :work
	has_one :education
	has_one :athlete
end
