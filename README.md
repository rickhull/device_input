# Device Input

We want to read events from e.g. `/dev/input/event0` in Ruby.  For example,
if you want to see what's happening "on the wire" when you press a special
function key on a laptop.  While this code can be used for the purpose of
malicious keystroke logging, it is not well suited for it and does not provide
the root privileges in order to read /dev/input.  Once you've got the
privilege to read /dev/input it's game over anyway.

## Rationale

`/dev/input/eventX` is just a character device.  Can't we read it with simple
Unix tooling?  Yes and no.  First of all, a character device just means that
it passes bytes (not necessarily characters or strings) from userspace into
the kernel.  Secondarily, the messages (defined as C structs) are in fact
binary and not strings or conventional characters.

So we'd like to be able to read entire messages, one at a time, decode them,
and display useful things like labels in the output.  It turns out that,
on my system at least, `/dev/input/event0` refuses reads that are not a
multiple of the data structure byte length.  So whatever tool used to read
the device must know about the data structure of the messages.

For a long time, it was pretty simple: 16 bytes.  8 bytes for timestamp,
2 bytes for metadata / classification, and a 2 byte value.  However, with
the widespread adoption of 64-bit platforms, timestamps in the kernel got
(conditionally) bigger.  The `long` type in C became platform-dependent:
32 bits (4 bytes) on a 32-bit platform and 64 bits (8 bytes) on a 64-bit
platform.  Since a timestamp is composed of 2 longs, the byte size for a
kernel input_event struct increases from 16 bytes to 24 bytes on a 64-bit
platform.

Any software must be aware of this distinction and choose the correct
underlying data types just to be able to delimit messages and perform a
successful read (without a decode).  This software does that, maps the encoded
values to friendly strings for display, and provides both library and
executable code to assist in examining kernel input events.

# Installation

Install the gem:

```
$ gem install device_input # sudo as necessary
```

Or, if using [Bundler](http://bundler.io/), add to your `Gemfile`:

```
gem 'device_input', '~> 0.0'
```

# Usage

```
$ sudo devsniff /dev/input/event0`
```

When the `f` key is pressed:

Output:
```
Misc:ScanCode:33
Key:F:0
Sync:Sync:0

```

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

What's a `timeval`?
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/linux/time.h#n15

```
struct timeval {
       __kernel_time_t          tv_sec;      /* seconds */
       __kernel_suseconds_t     tv_usec;     /* microseconds */
};
```

What's a `__kernel_time_t`?
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/asm-generic/posix_types.h#n88

```
typedef long            __kernel_long_t;
# ...
typedef __kernel_long_t         __kernel_suseconds_t;
# ...
typedef __kernel_long_t __kernel_time_t;
```

What's a `__u16`?  We're pretty sure it's an unsigned 16 bit integer.
Likewise `__s32` should be a signed 32-bit integer:

https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/include/uapi/asm-generic/int-l64.h#n23

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
(8 bytes).

This means that the event is 16 bytes on a 32-bit machine and 24 bytes on a
64-bit machine.  Software will need to accommodate.

## Ruby tools

We can use `RbConfig` and `Array#pack` to help us read these binary structs:

```
FIELD      C        RbConfig  Pack
tv_sec     long     long      l!
tv_usec    long     long      l!
type       __u16    uint16_t  S
code       __u16    uint16_t  S
value      __s32    int32_t   l
```
