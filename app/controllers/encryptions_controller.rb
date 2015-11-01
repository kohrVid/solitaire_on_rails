class EncryptionsController < ApplicationController
	def index
		@encryption = Encryption.new
	end

	def create
		@encryption = Encryption.new(encryption_params)
		upper_case = []
		(65..90).each do |i|
			upper_case.push(i)
		end
		message = @encryption.message.upcase.gsub(/[\W]/, '').scan(/.{5}/)
		keystream = @encryption.keystream.upcase.gsub(/[\W]/, '').scan(/.{5}/)
		message_list = []
		keystream_list = []
		message.each do |m|
			message_list.push(m.unpack("C*"))
		end
		keystream.each do |k|
			keystream_list.push(k.unpack("C*"))
		end
		sum = Matrix.rows(message_list) + Matrix.rows(keystream_list)
		letters = sum.map{|i|
			if upper_case.include?(i)
				i
			else 
				((i-129)%26) + 65
			end
		}
		code = []
		for j in 0..(letters.to_a.length - 1)
			code.push(letters.to_a[j].pack("C*"))
		end
		@code = code.to_s.gsub(/[^(\w\s)]/, '')
		if @encryption.save
			render 'index'
		else
			redirect_to root_path
		end

	end


	private
		def encryption_params
			params.require(:encryption).permit(:message, :keystream)
		end
end
