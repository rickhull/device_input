[![CI Status](https://github.com/rickhull/device_input/actions/workflows/ci.yaml/badge.svg)](https://github.com/rickhull/device_input/actions/workflows/ci.yaml)
[![Gem Version](https://badge.fury.io/rb/device_input.svg)](http://badge.fury.io/rb/device_input)
[![Code Climate](https://codeclimate.com/github/rickhull/device_input/badges/gpa.svg)](https://codeclimate.com/github/rickhull/device_input)

# Device Input

*for the Linux kernel*

This is a very basic tool for reading device input events from e.g.
`/dev/input/event0` in Ruby.  For example, in order to see what's happening
"on the wire" when a special laptop function key is pressed.  While this tool
can plausibly be used for the purpose of malicious keystroke logging, it is
not well suited for it and does not provide the root privileges in order to
read `/dev/input`.

Once you've given up the privilege to read `/dev/input` it's *game over* anyway.

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
`read()`, let alone a `decode()`.

To determine the message size, we need to know the data structure.  For a
long time, it was pretty simple: events are 16 bytes:

* timestamp - 8 bytes
* type - 2 bytes
* code - 2 bytes
* value - 4 bytes

However, this is only true for 32-bit platforms.  On 64-bit platforms, event
timestamps became 16 bytes, increasing the size of events from 16 to 24 bytes.
This is because a timestamp is defined (ultimately) as two `long`s, which
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

**REQUIREMENTS**

* Ruby >= 2.0

**DEPENDENCIES**

* none

Install the gem:
```shell
$ gem install device_input
```

Or, if using [Bundler](http://bundler.io/), add to your `Gemfile`:
```ruby
gem 'device_input', '~> 0.3'
```

# Usage

## Executable

```shell
$ evdump /dev/input/event0 # sudo as necessary
```

When the `f` key is pressed:
```
EV_MSC:ScanCode:33
EV_KEY:F:1
EV_SYN:SYN_REPORT:0
```

And released immediately (1=pressed, 0=released):
```
EV_MSC:ScanCode:33
EV_KEY:F:1
EV_SYN:SYN_REPORT:0
EV_MSC:ScanCode:33
EV_KEY:F:0
EV_SYN:SYN_REPORT:0
```

How about pretty mode?
```shell
$ sudo cat /dev/input/event0 | evdump --print pretty

# f

2017-01-24 05:29:43.923 Misc:ScanCode:33
2017-01-24 05:29:43.923 Key:F:1
2017-01-24 05:29:43.923 Sync:Report:0
2017-01-24 05:29:44.012 Misc:ScanCode:33
2017-01-24 05:29:44.012 Key:F:0
2017-01-24 05:29:44.012 Sync:Report:0
```

We can pull off the labels and go raw:
```shell
$ sudo cat /dev/input/event0 | evdump --print raw

# f

4:4:33
1:33:1
0:0:0
4:4:33
1:33:0
0:0:0
```

Fulfill your hacker-matrix fantasies:
```shell
$ sudo cat /dev/input/event0 | evdump --print hex

# f

00000000588757bd 00000000000046ca 0004 0004 00000021
00000000588757bd 00000000000046ca 0001 0021 00000001
00000000588757bd 00000000000046ca 0000 0000 00000000
00000000588757bd 000000000001a298 0004 0004 00000021
00000000588757bd 000000000001a298 0001 0021 00000000
00000000588757bd 000000000001a298 0000 0000 00000000
```

## Library

```ruby
require 'device_input'

File.open('/dev/input/event0', 'r') do |dev|
  # this loops forever and blocks waiting for input
  DeviceInput.read_loop(dev) do |event|
    puts event
    # break if event.time > start + 30
  end
end
```

An event has:

* `#data`: Struct of ints (class name Data)
* `#time`: Time, accurate to usecs
* `#type`: String label, possibly `UNK-X` where X is the integer from `#data`
* `#code`: String label, possibly `UNK-X-Y` where X and Y are from `#data`
* `#value`: Fixnum (signed) from `#data`

You will probably want to write your own read loop for your own project.
[`DeviceInput.read_loop`](lib/device_input.rb#L98) is very simple and can
easily be rewritten outside of this project's namespace and adapted for your
needs.

# Background

## Kernel docs

* https://www.kernel.org/doc/Documentation/input/input.txt
* https://www.kernel.org/doc/Documentation/input/event-codes.txt

### Kernel structs

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
typedef __kernel_long_t __kernel_suseconds_t;
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
    [event code labels](lib/device_input/labels.rb)
* Thanks to al2o3-cr from #ruby on Freenode for feedback
