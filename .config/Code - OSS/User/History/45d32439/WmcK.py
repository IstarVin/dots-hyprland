class CircularQueue:
    def __init__(self, size, name="main"):
        self.size = size  # Define the size of the queue
        self.name = name
        self.queue = [None] * size  # Initialize the queue with None
        self.front = self.rear = -1  # Both front and rear are initialized to -1

    # Check if the queue is full
    def isFull(self):
        return (self.rear + 1) % self.size == self.front

    # Check if the queue is empty
    def isEmpty(self):
        return self.front == -1

    # Add an element to the queue
    def enqueue(self, item):
        if self.isFull():
            print("Queue is full")
            return
        elif self.isEmpty():
            # First element being inserted
            self.front = self.rear = 0
        else:
            # Circular increment
            self.rear = (self.rear + 1) % self.size
        self.queue[self.rear] = item
        print(f"{self.name} Enqueued: {item}")

    # Remove an element from the queue
    def dequeue(self):
        if self.isEmpty():
            print("Queue is empty")
            return
        # Get the front element
        dequeued_item = self.queue[self.front]
        # Single element case, reset to initial state
        if self.front == self.rear:
            self.front = self.rear = -1
        else:
            # Circular increment
            self.front = (self.front + 1) % self.size
        print(f"{self.name} Dequeued: {dequeued_item}")
        return dequeued_item

    # Get the front element of the queue
    def Front(self):
        if self.isEmpty():
            print("Queue is empty")
            return None
        return self.queue[self.front]

    # Get the rear element of the queue
    def Rear(self):
        if self.isEmpty():
            print("Queue is empty")
            return None
        return self.queue[self.rear]

    # Display the elements of the queue
    def display(self):
        if self.isEmpty():
            print("Queue is empty")
            return
        print("Queue elements:")
        if self.rear >= self.front:
            print(self.queue[self.front : self.rear + 1])
        else:
            # When the queue wraps around
            print(self.queue[self.front : self.size] + self.queue[0 : self.rear + 1])


# Rotates the circular queue within the array implementation
# The front and rear points to the same element after rotation.
# def rotate(cq: CircularQueue, k):
#     k = k % cq.size
#     temp = CircularQueue(cq.size, "temp")
#
#     while not cq.isEmpty():
#         temp.enqueue(cq.dequeue())
#
#     for _ in range(k):
#         cq.enqueue(0)
#
#     cq.enqueue(temp.dequeue())
#
#     while not temp.isEmpty():
#         if cq.isFull():
#             cq.dequeue()
#         cq.enqueue(temp.dequeue())
#
#     return cq


# Rotates the circular queue within the array implementation
# The front still points to the first element
# THe rear still points to the last element
# def rotate1(cq: CircularQueue, k):
#     k = k % cq.size
#
#     if k == 0:
#         return cq
#
#     temp = CircularQueue(cq.size - k, "temp1")
#     temp1 = CircularQueue(k, "temp2")
#
#     for _ in range(cq.size - k):
#         temp.enqueue(cq.dequeue())
#
#     for _ in range(k):
#         temp1.enqueue(cq.dequeue())
#
#     while not temp1.isEmpty():
#         cq.enqueue(temp1.dequeue())
#
#     while not temp.isEmpty():
#         cq.enqueue(temp.dequeue())
#
#     return cq


# Only roates the head and rear
def rotate(cq: CircularQueue, k: int):
    for _ in range(cq.size - k % cq.size):
        cq.enqueue(cq.dequeue())


size = int(input("Enter queue size: "))
# size = 6

circular_queue = CircularQueue(size)

for i in range(size):
    # circular_queue.enqueue(i + 3)
    circular_queue.enqueue(int(input("Enter element: ")))

circular_queue.display()

k = int(input("Enter k: "))
# k = 2

print("Circular queue before rotation:", circular_queue.queue)
rotate(circular_queue, k)
print("Circular queue after rotation:", circular_queue.queue)

circular_queue.display()
# print(circular_queue.Front(), circular_queue.Rear())
