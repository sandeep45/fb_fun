class Facebook < ActiveRecord::Base
	belongs_to :user
	has_many :works
	has_many :educations
	has_many :athletes
end
