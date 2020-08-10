# Getting Started

This guide explains how to use `thread-local` for "global state".

## Installation

Add the gem to your project:

~~~ bash
$ bundle add thread-local
~~~

## Per-Class Thread Local Instance

In your own class, e.g. `FileCache`:

``` ruby
class FileCache
	extend Thread::Local
	
	def initialize
		@cache = {}
	end
	
	def load_file(path)
		@cache.fetch(path) do
			@cache[path] = File.read(path)
		end
	end
end
```

Now, instead of instantiating your cache `CACHE = FileCache.new`, use `FileCache.instance`. It will return a thread-local instance.

``` ruby
Thread.new do
	FileCache.instance
	# => #<FileCache:0x000055a14ec6be80>
end

Thread.new do
	FileCache.instance
	# => #<FileCache:0x000055a14ec597d0>
end
```

You may think, what is the point of a file cache which is not shared across all threads? And yes, you would be right. Within a single thread (i.e. application instance), files will be cached, but not between threads. The benefit of this approach is that it is the same level of isolation irrespective of the server being multi-process or multi-thread, and allows the server to manage application state on a per-thread basis (e.g. for rolling restarts/reloads).

### Non-global State

This wrapper is designed for state which would otherwise be global. It is not designed to be used to replace instance variables which would otherwise need to be thread-safe. For that, you should prefer things like [`Concurrent::Map`](https://www.rubydoc.info/gems/concurrent-ruby/Concurrent/Map).

### Extending Locals

In some cases, you might want to extend a thread local, e.g. change the way it's initialized or modify the object after it was initialized on demand. You can do this at the process-level using a module:

``` ruby
module WarmCache
	def local
		instance = super
		
		instance.load_file("/dev/random")
		
		return instance
	end
end

FileCache.extend(WarmCache)
```

When a file cache is created, it will also execute the code in `WarmCache#local`.
