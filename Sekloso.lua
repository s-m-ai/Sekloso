-- เสกของ & ปรับตัวละคร By Pumpkitz Hub
-- Theme: Ocean

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "เสกของ By Pumpkitz hub",
   LoadingTitle = "Pumpkitz Hub",
   LoadingSubtitle = "by Pumpkitz",
   Theme = "Ocean",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = false,
      FolderName = nil,
      FileName = "PumpkitzHub"
   },
   Discord = {
      Enabled = false,
   },
   KeySystem = false,
})

-- ==========================================
-- ฟังก์ชันดึงรายชื่อ Tool ทั้งหมดในแมพ
-- ==========================================
local function GetTools()
    local tools = {}
    local seen = {}
    local searchPlaces = {game.ReplicatedStorage, game.StarterPack, game.Workspace}
    
    local success, err = pcall(function()
        for _, place in pairs(searchPlaces) do
            for _, obj in pairs(place:GetDescendants()) do
                if obj:IsA("Tool") then
                    local name = obj.Name
                    if name ~= "" and not seen[name] then
                        seen[name] = true
                        table.insert(tools, name)
                    end
                end
            end
        end
    end)
    
    if not success then warn("Error getting tools: " .. tostring(err)) end
    table.sort(tools)
    return #tools == 0 and {"ไม่พบ Tool ในเกม"} or tools
end

local selectedTool = nil
local spawnCount = 1
local equipImmediately = false

-- ==========================================
-- แท็บที่ 1: 🎒 เสก Tool
-- ==========================================
local ToolTab = Window:CreateTab("🎒 เสก Tool", 4483362458)

local Section1 = ToolTab:CreateSection("📦 เลือก Tool")

local ToolDropdown = ToolTab:CreateDropdown({
   Name = "รายการ Tool ในแมพ",
   Options = GetTools(),
   CurrentOption = {"ไม่พบ Tool ในเกม"},
   MultipleOptions = false,
   Flag = "ToolDropdown",
   Callback = function(Options)
      selectedTool = type(Options) == "table" and Options[1] or Options
   end,
})

ToolTab:CreateButton({
   Name = "🔄 รีเฟรชรายการ Tool",
   Callback = function()
      local newTools = GetTools()
      Rayfield:Notify({ Title = "รีเฟรชสำเร็จ", Content = "พบ Tool " .. #newTools .. " รายการ", Time = 4 })
   end,
})

local Section2 = ToolTab:CreateSection("⚙️ ตั้งค่าการเสก")

ToolTab:CreateSlider({
   Name = "จำนวนครั้งที่เสก",
   Range = {1, 50},
   Increment = 1,
   Suffix = "ชิ้น",
   CurrentValue = 1,
   Flag = "SpawnCount",
   Callback = function(Value) spawnCount = Value end,
})

ToolTab:CreateToggle({
   Name = "⚔️ สวมใส่ให้ทันทีที่เสก",
   CurrentValue = false,
   Flag = "EquipImmediately",
   Callback = function(Value) equipImmediately = Value end,
})

local Section3 = ToolTab:CreateSection("🔨 คำสั่ง")

ToolTab:CreateButton({
   Name = "✅ ตกลง Build - เสก Tool",
   Callback = function()
      local player = game.Players.LocalPlayer
      
      if not selectedTool or selectedTool == "ไม่พบ Tool ในเกม" then
         Rayfield:Notify({ Title = "❌ ผิดพลาด", Content = "มึงเลือก Tool ก่อนดิ๊!", Time = 4 })
         return
      end
      
      if not player.Character or not player.Character:FindFirstChild("Humanoid") then
         Rayfield:Notify({ Title = "❌", Content = "ตัวละครมึงหายชิบหายแล้ว!", Time = 4 })
         return
      end
      
      local template = nil
      local searchPlaces = {game.ReplicatedStorage, game.StarterPack, game.Workspace}
      
      for _, place in pairs(searchPlaces) do
         for _, obj in pairs(place:GetDescendants()) do
            if obj:IsA("Tool") and obj.Name == selectedTool then
               template = obj
               break
            end
         end
         if template then break end
      end
      
      if not template then
         Rayfield:Notify({ Title = "❌", Content = "หา Tool '" .. selectedTool .. "' ไม่เจอว่ะ", Time = 4 })
         return
      end
      
      local spawnedCount = 0
      for i = 1, spawnCount do
         pcall(function()
            local clone = template:Clone()
            clone.Parent = player.Backpack
            spawnedCount = spawnedCount + 1
            
            if equipImmediately and i == 1 then
               player.Character.Humanoid:EquipTool(clone)
            end
         end)
      end
      
      Rayfield:Notify({ Title = "✅ เสกสำเร็จ!", Content = "ได้ '" .. selectedTool .. "' เข้ากระเป๋า x" .. spawnedCount, Time = 4 })
   end,
})

ToolTab:CreateButton({
   Name = "🗑️ ลบ Tool ที่เลือกออกจากกระเป๋า",
   Callback = function()
      if not selectedTool or selectedTool == "ไม่พบ Tool ในเกม" then return end
      local player = game.Players.LocalPlayer
      local count = 0
      
      for _, item in pairs(player.Backpack:GetChildren()) do
         if item:IsA("Tool") and item.Name == selectedTool then item:Destroy(); count = count + 1 end
      end
      if player.Character then
         for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name == selectedTool then item:Destroy(); count = count + 1 end
         end
      end
      
      Rayfield:Notify({ Title = "🗑️ ลบแล้ว", Content = "ลบ '" .. selectedTool .. "' ไป " .. count .. " ชิ้น", Time = 4 })
   end,
})

-- ==========================================
-- แท็บที่ 2: 🏃 ผู้เล่น (Player Mods)
-- ==========================================
local PlayerTab = Window:CreateTab("🏃 ผู้เล่น", 4483362458)

local PlayerSection1 = PlayerTab:CreateSection("⚡ ปรับค่าตัวละคร")

-- WalkSpeed Slider
PlayerTab:CreateSlider({
   Name = "🏃 ความเร็วเดิน (WalkSpeed)",
   Range = {16, 500},
   Increment = 1,
   Suffix = "",
   CurrentValue = 16,
   Flag = "WalkSpeedSlider",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = Value
      end
   end,
})

-- JumpPower Slider
PlayerTab:CreateSlider({
   Name = "🦘 พลังกระโดด (JumpPower)",
   Range = {50, 300},
   Increment = 1,
   Suffix = "",
   CurrentValue = 50,
   Flag = "JumpPowerSlider",
   Callback = function(Value)
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.UseJumpPower = true -- บังคับใช้ JumpPower แทน JumpHeight
         char.Humanoid.JumpPower = Value
      end
   end,
})

PlayerTab:CreateButton({
   Name = "🔄 รีเซ็ตค่าเริ่มต้น",
   Callback = function()
      local char = game.Players.LocalPlayer.Character
      if char and char:FindFirstChild("Humanoid") then
         char.Humanoid.WalkSpeed = 16
         char.Humanoid.UseJumpPower = true
         char.Humanoid.JumpPower = 50
         Rayfield:Notify({ Title = "✅ รีเซ็ตแล้ว", Content = "ความเร็วและพลังกระโดดกลับสู่ค่าปกติ", Time = 4 })
      end
   end,
})

local PlayerSection2 = PlayerTab:CreateSection("👻 พิเศษ")

-- NoClip Toggle
local noClipLoop = nil
PlayerTab:CreateToggle({
   Name = "👻 NoClip (ทะลุวัตถุ/เดินทะลุกำแพง)",
   CurrentValue = false,
   Flag = "NoClipToggle",
   Callback = function(Value)
      if Value then
         noClipLoop = game:GetService("RunService").Stepped:Connect(function()
            local char = game.Players.LocalPlayer.Character
            if char then
               for _, part in pairs(char:GetDescendants()) do
                  if part:IsA("BasePart") then
                     part.CanCollide = false
                  end
               end
            end
         end)
         Rayfield:Notify({ Title = "✅ เปิด NoClip", Content = "ตอนนี้มึงเดินทะลุทุกอย่างได้แล้ว!", Time = 4 })
      else
         if noClipLoop then
            noClipLoop:Disconnect()
            noClipLoop = nil
         end
         local char = game.Players.LocalPlayer.Character
         if char then
            for _, part in pairs(char:GetDescendants()) do
               if part:IsA("BasePart") then
                  part.CanCollide = true
               end
            end
         end
         Rayfield:Notify({ Title = "❌ ปิด NoClip", Content = "กลับสู่โหมดปกติ ชนกำแพงได้เหมือนเดิม", Time = 4 })
      end
   end,
})

-- About
ToolTab:CreateButton({
   Name = "ℹ️ เกี่ยวกับ",
   Callback = function()
      Rayfield:Notify({
         Title = "🎃 Pumpkitz Hub",
         Content = "เสก Tool & Player Mods v1.1\nTheme: Ocean\nBy Pumpkitz",
         Time = 6
      })
   end,
})

