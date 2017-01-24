# Device Input

*for the Linux kernel*

We want to read events from e.g. `/dev/input/event0` in Ruby.  For example,
if you want to see what's happening "on the wire" when you press a special
function key on a laptop.  While this code can be used for the purpose of
malicious keystroke logging, it is not well suited for it and does not provide
the root privileges in order to read `/dev/input`.  Once you've got the
privilege to read `/dev/input` it's *game over* anyway.

## Rationale

`/dev/input/eventX` is just a character device.  Can't we read it with simple
Unix tooling?  Yes and no.  First of all, a character device just means that
it passes bytes (not necessarily characters or strings) from userspace into
the kernel.  Secondarily, the messages (defined as C structs) are in fact
binary and not strings or conventional characters.

Since these are C structs (analagous to a binary message), we need to be able
to delimit individual messages and decode them.  We can't simply read a byte
at a time and try to make sense of it.  In fact, on my system,
`/dev/input/event0` refuses any read that is not a multiple of the struct /
message size, so we need to know the message size before even attempting a
read(), without even a decode().

To determine the message size, we need to know the data structure.  For a
long time, it was pretty simple: events are 16 bytes:

* timestamp - 8 bytes
* type - 2 bytes
* code - 2 bytes
* value - 4 bytes

However, this is only true for 32-bit platforms.  On 64-bit platforms, event
timestamps became 16 bytes, increasing the size of events from 16 to 24 bytes.
This is because a timestamp is defined (ultimately) as two `long`s, and as
everyone knows, two longs don't make a light.  No, wait -- it's that `long`s
are bigger on 64-bit platforms.  It's easy to remember:

* 32-bit platform: 32-bit `long` (4 bytes)
* 64-bit platform: 64-bit `long` (8 bytes)

`read(/dev/input/event0, 16)` will fail on a 64-bit machine.

Your tooling must be aware of this distinction and choose the correct
underlying data types just to be able to delimit messages and perform a
successful read.  This software does that, decodes the message, maps the
encoded values to friendly strings for display, and provides both library and
executable code to assist in examining kernel input events.

# Installation

Requirements: Ruby >= 2.0

Dependencies: none

Install the gem:
```
$ gem install device_input # sudo as necessary
```

Or, if using [Bundler](http://bundler.io/), add to your `Gemfile`:
```
gem 'device_input', '~> 0.1'
```

# Usage

## Executable

```
$ sudo devsniff /dev/input/event0
```

When the `f` key is pressed:
```
Misc:ScanCode:33
Key:F:1
Sync:Sync:0
```

And released:
```
Misc:ScanCode:33
Key:F:1
Sync:Sync:0
Misc:ScanCode:33
Key:F:0
Sync:Sync:0
```

## Library

```
require 'device_input'

# this loops forever and blocks waiting for input
DeviceInput.read_from('/dev/input/event0') do |event|
  puts event
  # break if event.time > start + 30
end
```

An event has:

* `#data`: Struct of ints (class name Data)
* `#time`: Time, accurate to usecs
* `#type`: String label, possibly `UNK-X` where X is the integer from `#data`
* `#code`: String label, possibly `UNK-X-Y` where X and Y are from `#data`
* `#value`: Fixnum (signed) from `#data`

You will probably want to write your own read loop for your own project.
[`DeviceInput.read_from`](lib/device_input.rb#L111) is very simple and can
easily be rewritten outside of this project's namespace and adapted for your
needs.

# Research

## Kernel docs

* https://www.kernel.org/doc/Documentation/input/input.txt
* https://www.kernel.org/doc/Documentation/input/event-codes.txt

These events are defined as C structs with a fixed size in bytes.  See more
about these structs towards the end of this document.

## Kernel structs

from https://www.kernel.org/doc/Documentation/input/input.txt
```
struct input_event {
       struct timeval time;
       unsigned short type;
       unsigned short code;
       unsigned int value;
};
```

from
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/input.h#n25
```
struct input_event {
       struct timeval time;
        __u16 type;
        __u16 code;
        __s32 value;
};
```

What's a [`timeval`](https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/time.h#n15)?
```
struct timeval {
       __kernel_time_t          tv_sec;      /* seconds */
       __kernel_suseconds_t     tv_usec;     /* microseconds */
};
```

What's a [`__kernel_time_t`](https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/asm-generic/posix_types.h#n88)?
```
typedef long            __kernel_long_t;
# ...
typedef __kernel_long_t         __kernel_suseconds_t;
# ...
typedef __kernel_long_t __kernel_time_t;
```

What's a [`__u16`](https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/asm-generic/int-l64.h#n23)?
We're pretty sure it's an unsigned 16 bit integer.  Likewise `__s32` should
be a signed 32-bit integer:
```
typedef unsigned short __u16;

typedef __signed__ int __s32;
```

Why is the value signed?  It's meant to be able to communicate an "analog"
range, say -127 to +127 as determined by the position of a joystick.

## Review

`input_event`

* time (timeval)
  - tv_sec (long)
  - tv_usec (long)
* type (__u16)
* code (__u16)
* value (__s32)

Flattened: `SEC` `USEC` `TYPE` `CODE` `VALUE`

How many bytes is a `long`?  Well, it's platform-dependent.  On a 32-bit
platform, you get 32 bits (4 bytes).  On a 64-bit platform you get 64 bits
(8 bytes).  This means that the event is 16 bytes on a 32-bit machine and
24 bytes on a 64-bit machine.  Software will need to accommodate.

## Ruby tools

We can use
[`RbConfig::SIZEOF`](http://idiosyncratic-ruby.com/42-ruby-config.html#rbconfigsizeof)
and `Array#pack`/`String#unpack` to help us read these binary structs:
```
FIELD      C        RbConfig  Pack
---        ---      ---       ---
tv_sec     long     long      l!
tv_usec    long     long      l!
type       __u16    uint16_t  S
code       __u16    uint16_t  S
value      __s32    int32_t   l
```

# Acknowledgments

* Inspired by https://github.com/prullmann/libdevinput (don't use it)
  - also the source of an early version of the
    [event code labels](lib/device_input/codes.rb)
* Thanks to al2o3-cr from #ruby on Freenode for feedback
