class DecryptionsController < ApplicationController
	def index
		@decryption = Decryption.new
	end

	def create
		@decryption = Decryption.new(decryption_params)
		@object = @decryption
		upper_case = []
		(65..90).each do |i|
			upper_case.push(i)
		end
		code = @decryption.code.upcase.gsub(/[\W]/, '').scan(/.{5}/)
		keystream = @decryption.keystream.upcase.gsub(/[\W]/, '').scan(/.{5}/)
		code_list = []
		keystream_list = []
		code.each do |c|
			code_list.push(c.unpack("C*"))
		end
		keystream.each do |k|
			keystream_list.push(k.unpack("C*"))
		end
		if keystream_list.length != code_list.length
			flash.now[:danger] = "Code and Keystream must contain the same number of letters"
		else
			sum = Matrix.rows(code_list) - Matrix.rows(keystream_list)
			letters = sum.map{|i|
				if i > 64
					i
				else 
					(i%26) + 64
				end
			}
			message = []
			for j in 0..(letters.to_a.length - 1)
				message.push(letters.to_a[j].pack("C*"))
			end
			@code = message.to_s.gsub(/[^(\w\s)]/, '')
		end
		if @decryption.save
			render 'index'
		else
			redirect_to decryption_path
		end

	end


	private
		def decryption_params
			params.require(:decryption).permit(:code, :keystream)
		end

end
