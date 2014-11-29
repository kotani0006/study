class Object
	def what?(result, *args)
		this = reserve_origin self

		public_methods(false).select do |m|
			self.method(m).arity == args.length && m != :freeze
		end.collect do |m|
			self.method m
		end.select do |m|
			begin
				cp = reserve_origin this
				m.unbind.bind(cp).call(*args) == result
			rescue
				next
			end
		end.collect do |m|
			m.name
		end
	end

	private

	def reserve_origin obj
		Marshal.load(Marshal.dump(obj))
	end
end

p "string".what? :string
