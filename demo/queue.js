// A tiny task queue, used for the motion demos.

const MAX_SIZE = 32;

function enqueue(queue, item)
{
    if (queue.length >= MAX_SIZE)
    {
        throw new Error("the queue is full");
    }
    queue.push(item);
    return queue.length;
}

function dequeue(queue)
{
    if (queue.length === 0)
    {
        return null;
    }
    return queue.shift();
}

function peek(queue)
{
    return queue.length ? queue[0] : null;
}

function drain(queue, handler)
{
    while (queue.length > 0)
    {
        handler(dequeue(queue));
    }
    return queue;
}

module.exports = { enqueue, dequeue, peek, drain };
