# Background

We want to read events from e.g. `/dev/input/event0` in Ruby.

## Kernel docs

* https://www.kernel.org/doc/Documentation/input/input.txt
* https://www.kernel.org/doc/Documentation/input/event-codes.txt

These events are defined as C structs with a fixed size in bytes.

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

Let's review:

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

We can use `RbConfig` and `Array#pack` to help us read these binary structs:

```
FIELD      C        RbConfig  Pack
tv_usec    long     long      l!
tv_usec    long     long      l!
type       __u16    uint16_t  S
code       __u16    uint16_t  S
value      __s32    int32_t   l
```
