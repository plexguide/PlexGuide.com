try:
    # Try the Python 3 queue module
    import queue
except ImportError:
    # Fallback to the Python 2 Queue module
    import Queue as queue
import datetime
import copy
import threading


class PriorityLock:
    def __init__(self):
        self._is_available = True
        self._mutex = threading.Lock()
        self._waiter_queue = queue.PriorityQueue()

    def acquire(self, priority=0):
        self._mutex.acquire()
        # First, just check the lock.
        if self._is_available:
            self._is_available = False
            self._mutex.release()
            return True
        event = threading.Event()
        self._waiter_queue.put((priority, datetime.datetime.now(), event))
        self._mutex.release()
        event.wait()
        # When the event is triggered, we have the lock.
        return True

    def release(self):
        self._mutex.acquire()
        # Notify the next thread in line, if any.
        try:
            _, timeAdded, event = self._waiter_queue.get_nowait()
        except queue.Empty:
            self._is_available = True
        else:
            event.set()
        self._mutex.release()


class Thread:
    def __init__(self):
        self.threads = []

    def start(self, target, name=None, args=None, track=False):
        thread = threading.Thread(target=target, name=name, args=args if args else [])
        thread.daemon = True
        thread.start()
        if track:
            self.threads.append(thread)
        return thread

    def join(self):
        for thread in copy.copy(self.threads):
            thread.join()
            self.threads.remove(thread)
        return

    def kill(self):
        for thread in copy.copy(self.threads):
            thread.kill()
            self.threads.remove(thread)
        return
