---
title: Windows Thread
date: 05/17/2017
category: Notes
tags:
    - Windows
    - CLR
    - Thread
---

> DRAFT VERSION

# Thread Basic
1. backgroup: OS only one `Thread` of execution that ran through the entire system.
    - includes both OS code/data and application code/data
    - exclusive, prevent other tasks from executing
    - application may cause infinite loop and block entire OS

2. Process:
    - each instance of application is a `process`
    - `process` is a collection of resources that's used by a single instance of application
    - virtual address space, isolated domain protection
    - depends on and limit to CPU cores
    - `process` is expensive in Windows, it may take several seconds to create a process (allocate & initialize memory, load exe/dll for disk, etc.)

3. Thread
    - every `Thread` has each of following: `Thread Kernal Object`, `Thread Environment Block (TEB)`, `User-mode Stack`, `Kernal-mode Stack`, `DLL thread-attach and thread-detach notifications`(unmanaged programming only). => all these would be allocated when creating a thread => so a thread itself may take some momery space (at least 1MB+ per thread).

    - `context switching`, CPU has fixed number cores, that threads size may far greater than CPU core number, that CPU allow a thread to run for a **`time-slice`**. (__Because CPU core can only do one thine at a time__). Whenever the `time-slice` for a thread expires, that `Windows Context` switches to another thread.
    - `Thread` is the basic dispatcher unit by CPU.
    - `optimum number of threads` is the number of CPU cores. (since there's no context switching, and threads run at full speed)
    - don't `abuse` thread, __stop the madness!__
    - don't `block` thread, should perform async operations

4. CLR Threads vs Windows Threads
    - a CLR thread is identical to a Windows Thread

5. Brief Points:
    - 进程(`Process`)是运行程序的实例; 内存空间独立; ( => 进程通信);
    - 线程(`Thread`)是CPU的基本调度单元; 内存空间共享; ( => 线程同步);

6. Two kind of Async Operations:
    - `Compute-Bound`:  requires a thread to do the work
    - `I/O-Bound`:  device driver has hardware to do the work; no thread required.

7. Thread Schedule and Priorities
    - Windows is **NOT** a `Real-Time Operating System`
    - Every thread is assigned a priority level ranging from `0 (the lowest)` to `31 (the highest)`
    - Higher-priority threads always `preempt`(抢占) lower-priority threads, regardless of what the lower-priority threads are executing.
    - A `zero page thread` creates on system boot, the lowest priority, when there's no any other high priority threads need to work, so it's turn to work, `to zeroing any free pages of RAM in system`. ( `priority 0 is reserved ofor the zero page thread`)
    -  Process Priority and Relative Thread Priority Mapping
        | Thread / Process | Real time | High | Above Normal | Normal | Below Normal | Idle |
        |------------------|-----------|------|-------------|--------|-------------|------|
        | Time critical | 31 | 15 | 15 | 15 | 15 | 15 |
        | Highest | 26 | 15 | 12 | 10 | 8 | 6 |
        | Above normal | 25 | 14 | 11 | 9 | 7 | 5 |
        | Normal | 24 | 13 | 10 | 8 | 6 | 4 |
        | Below normal | 23 | 12 | 9 | 7 | 5 | 3 |
        | Lowest | 22 | 11 | 8 | 6 | 4 | 2 |
        | Idle | 16 | 1 | 1 | 1 | 1 | 1 |

8. Foregroud Threads vs. Backgroud Threads
    -  CLR consider every thread to be either a foregroud or a backgroud thread.
    -  When all foreground threads in a process stop running, then CLR force stops any backgroud threads regardless if background threads are still running.

```javascript
var about = {
    name:'xiao-fang',
    site:'http://xiao-fang.me',
    intro: 'code to live, live to code...'
}
```

# Compute-Bound Async Operations
1. about
    - low usage rate of CPU
2. Thread Pool
    - why threads should be improved?
        -   creating/destroying a thread is an expensive operation in terms of time
        -   having a lot of threads wastes memory resource and impact on performance because of context switching between threads.
    - How `ThreadPool` works?
        - `initialize` with CLR, `one` ThreadPool per CLR
        - internally, the thread pool maintains a `queue` of operation requests
        - whatever application can `append requests` in queue by call some ThreadPool method
        - requests in thread pool queue would be `run` in some order by time or priority
        - thread pool `reuse` threads
        - thread pool `create more threads` if there are many requests, otherwise if requests decrese, the thread pool `threads kill themselves`.


# References

- CLR Via C#, 4th Edition, by Jeffrey `Richter`
- [进程与线程的一个简单解释](http://www.ruanyifeng.com/blog/2013/04/processes_and_threads.html)