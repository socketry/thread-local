# frozen_string_literal: true

# Released under the MIT License.
# Copyright, 2020, by Samuel Williams.

require 'thread/local'

class MyThing
	extend Thread::Local
end

RSpec.describe Thread::Local do
	it "has a version number" do
		expect(Thread::Local::VERSION).not_to be nil
	end
	
	describe '#instance' do
		it "creates unique instances in different threads" do
			instance1 = Thread.new do
				MyThing.instance
			end.value
			
			instance2 = Thread.new do
				MyThing.instance
			end.value
			
			expect(instance1).to_not be instance2
		end
		
		it "returns same instance in same thread" do
			expect(MyThing.instance).to be MyThing.instance
		end
	end
	
	describe '#instance=' do
		let(:object) {Object.new}
		
		it "can assign an object to the thread local instance" do
			MyThing.instance = object
			
			expect(MyThing.instance).to be object
		end
	end
end
