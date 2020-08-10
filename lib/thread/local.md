# Thread::Local

Implements a standard interface for per-class/module thread local instances.

## Per-Class Instance

By default, classes are instantiated using `self.new`:

~~~ ruby
require 'thread/local'

class MyClass
	extend Thread::Local
end

p MyClass.instance
~~~

### Extensions

If you need to change the behaviour of an existing thread local, you can prepend a module to wrap the call to `self.new`:

~~~ ruby
require 'thread/local'

class MyClass
	extend Thread::Local
	
	attr_accessor :data
end

module MyExtension
	def local
		instance = super
		
		# Do something with the thread local instance, e.g.:
		instance.data = [1, 2, 3]
		
		return instance
	end
end

MyClass.extend(MyExtension)

p MyClass.instance
~~~

### Assignment

Generally, you should avoid assigning to the thread-local instance. You should prefer extensions as outlined above. However, in some situations (e.g. testing) you may prefer to directly assign to the thread local:

~~~ruby
require 'thread/local'

class MyClass
	extend Thread::Local
end

# Change the instance for the current thread:
MyClass.instance = Object.new

p MyClass.instance
~~~

## Per-Module Instance

By default, you cannot instantiate a module. So, you must implement your own `self.new` method:

~~~ ruby
require 'thread/local'

module MyModule
	extend Thread::Local
	
	def self.new
		Object.new
	end
end

p MyModule.instance
~~~