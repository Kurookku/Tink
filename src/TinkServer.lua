local TinkServer = {}

local function init1()
    task.wait(1)
    print("Started 1")
end

local function init2()
    task.wait(2)
    print("Started 2")
end

local function init3()
    task.wait(3)
    print("Started 3")
end

local function init4()
    task.wait(4)
    print("Started 4")
end

local function start()
    local threads = {}
    local mainThread = coroutine.running()
    local mainThreadWaiting = false
    local done = 0

    local function report(fn)
        return task.spawn(function()
            -- Call the function:
            local success, err = pcall(fn)
            done += 1

            -- Handle the error somehow:
            if not success then
                warn(err)
            end

            -- Resume main thread if needed:
            if done == #threads and mainThreadWaiting then
                task.spawn(mainThread)
            end
        end)
    end

    -- Start all threads:
    table.insert(threads, report(init1))
    table.insert(threads, report(init2))
    table.insert(threads, report(init3))
    table.insert(threads, report(init4))

    -- It's possible that none of them yielded, thus all
    -- are done immediately. But if one or more yielded,
    -- we'll yield here too and wait.
    if done ~= #threads then
        mainThreadWaiting = true
        coroutine.yield()
        mainThreadWaiting = false
    end

    -- All done
    print("Finished")
end
start()

return TinkServer