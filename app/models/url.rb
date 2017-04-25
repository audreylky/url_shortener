class Url < ApplicationRecord
	validates :long_url, presence: true
	# validate :url_exist? # custom validation

	before_create do
		self.long_url = valid_url?
		# self.short_url = short
		# valid_short?
	end

	def valid_url?
		# http:// or not http://
		x = self.long_url.start_with?("http://", "https://")
		if  x == false
			return "http://" + self.long_url
		else
			return self.long_url
		end
	end

# valid link that can be assessed?
	def url_exist?
		begin
			uri = URI.parse(valid_url?)
			response = Net::HTTP.get_response(uri)
		rescue 
			errors.add(:long_url,"is invalid url")
			# in AR, error is a class by itself already 
			# go to static.rb to check the errors
		end
	end

	def short
		SecureRandom.hex(3.5)  # 2 * n
	end

	# def valid_short?
	# 	if Url.exists?(:short_url => self.short_url)
	# 		self.short_url = short
	# 		valid_short?
	# 	else
	# 		return self.short_url
	# 	end
	# end
end
