# Thread::Local ![Development](https://github.com/socketry/thread-local/workflows/Development/badge.svg?branch=master)

A module to simplify thread-local state.

## Motivation

In my own web framework, [utopia](https://github.com/socketry/utopia), I have been struggling with the best way to expose configuration details. I was setting both global variables and modifying `ENV` which made it impossible to have multiple isolated instances of the application in the same process. This in turn makes it hard to implement things like graceful restart in multi-threaded [falcon](https://github.com/socketry/falcon). Such issues also affect application code running in other multi-threaded contexts, which are becoming increasingly common (e.g. JRuby, TruffleRuby).

Global variables are often not thread-safe and encourage poor programming style. In many cases it is desirable to have thread-local state, but implementing this directly in Ruby is unpleasant at best. This gem provides a best-practice wrapper which can extend existing classes to provide per-thread instances.

Conceptually, a thread is a container for application state. This works well when servers consider applications to be isolated on a per-thread basis, but this isn't always the case:

| Server               | Application      | Thread Safety            |
|----------------------|------------------|--------------------------|
| Falcon Multi-Process | One per process. | Isolated.                |
| Falcon Multi-Thread  | One per thread.  | Isolated, Shared State.  |
| Puma Multi-Thread    | One per process. | Reentrant, Shared State. |
| Puma Cluster         | One per worker.  | Reentrant, Shared State. |
| Unicorn              | One per process. | Isolated.                |

Puma requires applications to be completely thread safe and reentrant, which isn't always easy. However, this gem attempts to provide a model which works in all the above servers, providing isolated, thread-safe, mutable per-thread state.

## Installation

```
bundle add thread-local
```

## Usage

In your own class:

```ruby
class MyThing
	extend Thread::Local
end
```

Now, instead of instantiating your class `MyThing.new`, use `MyThing.instance`. It will return a thread-local instance.

```ruby
Thread.new do
	MyThing.instance
	# => #<MyObject:0x000055a14ec6be80>
end

Thread.new do
	MyThing.instance
	# => #<MyObject:0x000055a14ec597d0>
end
```

Use this as a thread-safe alternative to globals.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Released under the MIT license.

Copyright, 2020, by [Samuel G. D. Williams](https://www.codeotaku.com).

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
