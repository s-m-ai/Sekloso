-- เสกของ (Tool) By Pumpkitz Hub
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

-- ฟังก์ชันดึงรายชื่อ Tool ทั้งหมดในแมพ
local function GetTools()
    local tools = {}
    local seen = {}
    -- แหล่งที่มักจะซ่อน Tool ไว้
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
    
    if not success then
        warn("Error getting tools: " .. tostring(err))
    end
    
    table.sort(tools)
        if #tools == 0 then
        return {"ไม่พบ Tool ในเกม"}
    end
    
    return tools
end

local selectedTool = nil
local spawnCount = 1
local equipImmediately = false

-- Tab หลัก
local MainTab = Window:CreateTab("🎒 เสก Tool", 4483362458)

local Section1 = MainTab:CreateSection("📦 เลือก Tool")

-- Dropdown เลือก Tool
local ToolDropdown = MainTab:CreateDropdown({
   Name = "รายการ Tool ในแมพ",
   Options = GetTools(),
   CurrentOption = {"ไม่พบ Tool ในเกม"},
   MultipleOptions = false,
   Flag = "ToolDropdown",
   Callback = function(Options)
      if type(Options) == "table" then
         selectedTool = Options[1]
      else
         selectedTool = Options
      end
   end,
})

-- ปุ่มรีเฟรช
MainTab:CreateButton({
   Name = "🔄 รีเฟรชรายการ Tool",
   Callback = function()
      local newTools = GetTools()
      Rayfield:Notify({
         Title = "รีเฟรชสำเร็จ",
         Content = "พบ Tool " .. #newTools .. " รายการ",
         Time = 4
      })
   end,
})

local Section2 = MainTab:CreateSection("⚙️ ตั้งค่าการเสก")

-- จำนวน
MainTab:CreateSlider({
   Name = "จำนวนครั้งที่เสก",   Range = {1, 50},
   Increment = 1,
   Suffix = "ชิ้น",
   CurrentValue = 1,
   Flag = "SpawnCount",
   Callback = function(Value)
      spawnCount = Value
   end,
})

-- Toggle สวมใส่ทันที
MainTab:CreateToggle({
   Name = "⚔️ สวมใส่ให้ทันทีที่เสก",
   CurrentValue = false,
   Flag = "EquipImmediately",
   Callback = function(Value)
      equipImmediately = Value
   end,
})

local Section3 = MainTab:CreateSection("🔨 คำสั่ง")

-- ปุ่ม Build หลัก (เสก Tool)
MainTab:CreateButton({
   Name = "✅ ตกลง Build - เสก Tool",
   Callback = function()
      local player = game.Players.LocalPlayer
      
      if not selectedTool or selectedTool == "ไม่พบ Tool ในเกม" then
         Rayfield:Notify({
            Title = "❌ ผิดพลาด",
            Content = "มึงเลือก Tool ก่อนดิ๊!",
            Time = 4
         })
         return
      end
      
      if not player.Character or not player.Character:FindFirstChild("Humanoid") then
         Rayfield:Notify({
            Title = "❌",
            Content = "ตัวละครมึงหายชิบหายแล้ว!",
            Time = 4
         })
         return
      end
      
      -- หาต้นแบบ Tool
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
         Rayfield:Notify({
            Title = "❌",
            Content = "หา Tool '" .. selectedTool .. "' ไม่เจอว่ะ",
            Time = 4
         })
         return
      end
      
      -- เริ่มกระบวนการเสก
      local spawnedCount = 0
      for i = 1, spawnCount do
         local success, err = pcall(function()
            local clone = template:Clone()
            clone.Parent = player.Backpack
            spawnedCount = spawnedCount + 1
            
            -- ถ้ามึงติ๊กให้สวมใส่ทันที
            if equipImmediately and i == 1 then
               player.Character.Humanoid:EquipTool(clone)
            end
         end)
         
         if not success then
            warn("Spawn Tool error: " .. tostring(err))
         end
      end
      
      Rayfield:Notify({
         Title = "✅ เสกสำเร็จ!",
         Content = "ได้ '" .. selectedTool .. "' เข้ากระเป๋า x" .. spawnedCount,
         Time = 4
      })
   end,
})

-- ปุ่มลบ Tool ที่เสกออกไป (ล้างกระเป๋า)
MainTab:CreateButton({
   Name = "🗑️ ลบ Tool ที่เลือกออกจากกระเป๋า",
   Callback = function()      if not selectedTool or selectedTool == "ไม่พบ Tool ในเกม" then return end
      
      local player = game.Players.LocalPlayer
      local count = 0
      
      -- ลบในกระเป๋า
      for _, item in pairs(player.Backpack:GetChildren()) do
         if item:IsA("Tool") and item.Name == selectedTool then
            item:Destroy()
            count = count + 1
         end
      end
      
      -- ลบในมือตัวละครด้วย (ถ้าถืออยู่)
      if player.Character then
         for _, item in pairs(player.Character:GetChildren()) do
            if item:IsA("Tool") and item.Name == selectedTool then
               item:Destroy()
               count = count + 1
            end
         end
      end
      
      Rayfield:Notify({
         Title = "🗑️ ลบแล้ว",
         Content = "ลบ '" .. selectedTool .. "' ไป " .. count .. " ชิ้น",
         Time = 4
      })
   end,
})

-- About
MainTab:CreateButton({
   Name = "ℹ️ เกี่ยวกับ",
   Callback = function()
      Rayfield:Notify({
         Title = "🎃 Pumpkitz Hub",
         Content = "เสก Tool v1.0\nTheme: Ocean\nBy Pumpkitz",
         Time = 6
      })
   end,
})
