---
title: Windows Thread
date: 05/17/2017
category: Notes
tags:
    - Windows
    - CLR
    - CLR via C#
    - Thread
---

> DRAFT VERSION

# Thread Basic

### background
OS only one `Thread` of execution that ran through the entire system.
- includes both OS code/data and application code/data
- exclusive, prevent other tasks from executing
- application may cause infinite loop and block entire OS

### Process:
- each instance of application is a `process`
- `process` is a collection of resources that's used by a single instance of application
- virtual address space, isolated domain protection
- depends on and limit to CPU cores
- `process` is expensive in Windows, it may take several seconds to create a process (allocate & initialize memory, load exe/dll for disk, etc.)

### Thread
- every `Thread` has each of following: `Thread Kernal Object`, `Thread Environment Block (TEB)`, `User-mode Stack`, `Kernal-mode Stack`, `DLL thread-attach and thread-detach notifications`(unmanaged programming only). => all these would be allocated when creating a thread => so a thread itself may take some momery space (at least 1MB+ per thread).

- `context switching`, CPU has fixed number cores, that threads size may far greater than CPU core number, that CPU allow a thread to run for a **`time-slice`**. (__Because CPU core can only do one thine at a time__). Whenever the `time-slice` for a thread expires, that `Windows Context` switches to another thread.
- `Thread` is the basic dispatcher unit by CPU.
- `optimum number of threads` is the number of CPU cores. (since there's no context switching, and threads run at full speed)
- don't `abuse` thread, __stop the madness!__
- don't `block` thread, should perform async operations

### CLR Threads vs Windows Threads
- a CLR thread is identical to a Windows Thread

### Brief
- 进程(`Process`)是运行程序的实例; 内存空间独立; ( => 进程通信);
- 线程(`Thread`)是CPU的基本调度单元; 内存空间共享; ( => 线程同步);

### Two kind of Async Operations:
- `Compute-Bound`:  requires a thread to do the work
- `I/O-Bound`:  device driver has hardware to do the work; no thread required.

### Thread Schedule and Priorities
- Windows is **NOT** a `Real-Time Operating System`
- Every thread is assigned a priority level ranging from `0 (the lowest)` to `31 (the highest)`
- Higher-priority threads always `preempt`(抢占) lower-priority threads, regardless of what the lower-priority threads are executing.
- A `zero page thread` creates on system boot, the lowest priority, when there's no any other high priority threads need to work, so it's turn to work, `to zeroing any free pages of RAM in system`. ( `priority 0 is reserved ofor the zero page thread`)
-  Process Priority and Relative Thread Priority Mapping

    | Thread / Process | Real time | High | AboveNormal | Normal | BelowNormal | Idle |
    |------------------|-----------|------|-------------|--------|-------------|------|
    | Time critical    | 31        | 15   | 15          | 15     | 15          | 15   |
    | Highest          | 26        | 15   | 12          | 10     | 8           | 6    |
    | Above normal     | 25        | 14   | 11          | 9      | 7           | 5    |
    | Normal           | 24        | 13   | 10          | 8      | 6           | 4    |
    | Below normal     | 23        | 12   | 9           | 7      | 5           | 3    |
    | Lowest           | 22        | 11   | 8           | 6      | 4           | 2    |
    | Idle             | 16        | 1    | 1           | 1      | 1           | 1    |

### Foregroud Threads vs. Backgroud Threads
-  CLR consider every thread to be either a foregroud or a backgroud thread.
-  When all foreground threads in a process stop running, then CLR force stops any backgroud threads regardless if background threads are still running.

# Compute-Bound Async Operations
### Thread Pool
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
- Practice
    ```csharp
    static Boolean QueueUserWorkItem(WaitCallback callBack);
    static Boolean QueueUserWorkItem(WaitCallback callBack, Object state);
    ```
### Execution Contexts
- every thread has an `execution context` associated to it.
- `execution context` includes such as,
    -  security settings (compressed stack, Thread’s Principal property, and Windows identity)
    - host settings (see System.Threading.HostExecutionContextManager)
    - logical call context data (see System.Runtime.Remoting.Messaging.CallContext’s LogicalSetData and LogicalGetData methods).
- thread `a` invokes thread `b`, then CLR auto cause thread `a`'s execctution context to `flow (be copied)` to thread `b`. Also, the `Executionontext` could be `suppress/restore` programmingly as following. If thread `a` suppress flow, then thread `b` cannot access to thread `a` context.

    ```c
    public sealed class ExecutionContext : IDisposable, ISerializable
    {
        [SecurityCritical] public static AsyncFlowControl SuppressFlow();
        public static void RestoreFlow();
        public static Boolean IsFlowSuppressed();
        // Less commonly used methods are not shown
    }
    ```
### Cooperative Cancellation and Timeout
-  .NET fromework offers a standard pattern for canceling operations, is `cooperative`
-  `System.Threading.CancellationTokenSource`.
    -   the `Token` is __readonly__, auto-generated on CancellationTokenSource creation.

    ```csharp
    public sealed class CancellationTokenSource : IDisposable
    {
        public CancellationTokenSource();
        public Boolean IsCancellationRequested { get; }
        public CancellationToken Token { get; }
        public void Cancel(); // Internally, calls Cancel passing false
        public void Cancel(Boolean throwOnFirstException);
        // other members
    }
    ```

-  `CancellationToken` instance is a lightweight value type.
    -   any cancel actions can be `Register` within token, that can use `Dispose` to release registered callback from token source.

    ```csharp
    public struct CancellationToken
    {
        public static CancellationToken None { get; } // Very convenient
        public Boolean IsCancellationRequested { get; } // Called by non­Task invoked operations
        public void ThrowIfCancellationRequested(); // Called by Task­invoked operations
        public WaitHandle WaitHandle { get; } // WaitHandle is signaled when the CancellationTokenSource is canceled
        public CancellationTokenRegistration Register(/** multiple overloads */);
        // other members
    }
    ```
- `CancellationToken’s Register` to register callbacks from token source that would be invoked when calling `Cancel`.

### Tasks
xx
-
# References

- CLR Via C#, 4th Edition, by `Jeffrey Richter`
- [进程与线程的一个简单解释](http://www.ruanyifeng.com/blog/2013/04/processes_and_threads.html)

# About Me

```javascript
var about = {
    name:'xiao-fang',
    site:'http://xiao-fang.me',
    intro: 'code to live, live to code...'
}
```