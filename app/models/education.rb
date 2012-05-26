class Education < ActiveRecord::Base
	belongs_to :facebook
	has_one :concentration
end
