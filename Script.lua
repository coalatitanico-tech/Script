-- AOTR HUB COMPLETO
-- Vida + Gás + ESP + Mini mapa corrigido

local p=game.Players.LocalPlayer
local rs=game:GetService("RunService")

local gui=Instance.new("ScreenGui",p.PlayerGui)
gui.ResetOnSpawn=false

-- BOTÃO MENU
local open=Instance.new("TextButton",gui)
open.Size=UDim2.new(0,50,0,50)
open.Position=UDim2.new(0,10,0.5,-25)
open.Text="☰"
open.TextScaled=true
open.BackgroundColor3=Color3.fromRGB(30,30,30)
open.TextColor3=Color3.new(1,1,1)

-- MENU
local menu=Instance.new("Frame",gui)
menu.Size=UDim2.new(0,180,0,220)
menu.Position=UDim2.new(0,70,0.5,-110)
menu.BackgroundColor3=Color3.fromRGB(20,20,20)
menu.Visible=false

open.MouseButton1Click:Connect(function()
	menu.Visible=not menu.Visible
end)

-- CRIAR BOTÕES
local function button(txt,y)
	local b=Instance.new("TextButton",menu)
	b.Size=UDim2.new(1,-10,0,40)
	b.Position=UDim2.new(0,5,0,y)
	b.Text=txt
	b.TextScaled=true
	b.BackgroundColor3=Color3.fromRGB(40,40,40)
	b.TextColor3=Color3.new(1,1,1)
	return b
end

local hpBtn=button("Vida",10)
local gasBtn=button("Gas",60)
local mapBtn=button("Mini mapa",110)
local espBtn=button("ESP Titãs",160)

------------------------------------------------
-- VIDA
------------------------------------------------

local hpOn=false
local hpGui

hpBtn.MouseButton1Click:Connect(function()

	hpOn=not hpOn

	if hpOn then

		local c=p.Character or p.CharacterAdded:Wait()
		local h=c:WaitForChild("Humanoid")

		hpGui=Instance.new("TextLabel",gui)
		hpGui.Size=UDim2.new(0,200,0,40)
		hpGui.Position=UDim2.new(.5,-100,0,10)
		hpGui.BackgroundTransparency=.3
		hpGui.BackgroundColor3=Color3.new(0,0,0)
		hpGui.TextScaled=true
		hpGui.TextColor3=Color3.new(1,1,1)

		local function update()
			hpGui.Text="HP: "..math.floor(h.Health)
		end

		update()
		h.HealthChanged:Connect(update)

	else
		if hpGui then hpGui:Destroy() end
	end
end)

------------------------------------------------
-- GÁS
------------------------------------------------

local gasOn=false
local gasGui

gasBtn.MouseButton1Click:Connect(function()

	gasOn=not gasOn

	if gasOn then

		local c=p.Character or p.CharacterAdded:Wait()
		local gas=c:FindFirstChild("Gas")

		gasGui=Instance.new("TextLabel",gui)
		gasGui.Size=UDim2.new(0,200,0,40)
		gasGui.Position=UDim2.new(.5,-100,50)
		gasGui.BackgroundTransparency=.3
		gasGui.BackgroundColor3=Color3.new(0,0,0)
		gasGui.TextScaled=true
		gasGui.TextColor3=Color3.new(0,1,1)

		if gas then

			local function update()
				gasGui.Text="GÁS: "..math.floor(gas.Value)
			end

			update()
			gas:GetPropertyChangedSignal("Value"):Connect(update)

		else
			gasGui.Text="Gas não encontrado"
		end

	else
		if gasGui then gasGui:Destroy() end
	end
end)

------------------------------------------------
-- MINI MAPA
------------------------------------------------

local mapOn=false
local minimap
local mapLoop

mapBtn.MouseButton1Click:Connect(function()

	mapOn=not mapOn

	if mapOn then

		local c=p.Character or p.CharacterAdded:Wait()
		local hrp=c:WaitForChild("HumanoidRootPart")

		minimap=Instance.new("Frame",gui)
		minimap.Size=UDim2.new(0,170,0,170)
		minimap.Position=UDim2.new(1,-180,0,10)
		minimap.BackgroundColor3=Color3.fromRGB(20,20,20)
		minimap.ClipsDescendants=true

		local me=Instance.new("Frame",minimap)
		me.Size=UDim2.new(0,8,0,8)
		me.Position=UDim2.new(.5,-4,.5,-4)
		me.BackgroundColor3=Color3.new(0,1,0)
		me.BorderSizePixel=0

		local scale=8

		mapLoop=rs.RenderStepped:Connect(function()

			if not minimap then return end

			for _,v in pairs(minimap:GetChildren()) do
				if v.Name=="TitanDot" then
					v:Destroy()
				end
			end

			local folder=workspace:FindFirstChild("Titans")

			if folder then
				for _,titan in pairs(folder:GetChildren()) do

					local root=titan:FindFirstChild("HumanoidRootPart")

					if root then

						local dx=(root.Position.X-hrp.Position.X)/scale
						local dz=(root.Position.Z-hrp.Position.Z)/scale

						dx=math.clamp(dx,-80,80)
						dz=math.clamp(dz,-80,80)

						local dot=Instance.new("Frame")
						dot.Name="TitanDot"
						dot.Size=UDim2.new(0,6,0,6)
						dot.BorderSizePixel=0
						dot.BackgroundColor3=Color3.new(1,0,0)

						local dist=(Vector3.new(dx,0,dz)).Magnitude

						if dist < 3 then
							dot.Size=UDim2.new(0,10,0,10)
							dot.BackgroundColor3=Color3.new(1,1,0)
						end

						dot.Position=UDim2.new(.5,dx-3,.5,dz-3)
						dot.Parent=minimap
					end
				end
			end
		end)

	else

		if mapLoop then
			mapLoop:Disconnect()
		end

		if minimap then
			minimap:Destroy()
			minimap=nil
		end
	end
end)

------------------------------------------------
-- ESP TITÃS
------------------------------------------------

local esp=false

espBtn.MouseButton1Click:Connect(function()

	esp=not esp

	local folder=workspace:FindFirstChild("Titans")

	if folder then
		for _,t in pairs(folder:GetChildren()) do

			if esp then

				if not t:FindFirstChild("ESP") then

					local h=Instance.new("Highlight")
					h.Name="ESP"
					h.FillColor=Color3.new(1,0,0)
					h.FillTransparency=.5
					h.Parent=t

				end

			else

				local e=t:FindFirstChild("ESP")

				if e then
					e:Destroy()
				end
			end
		end
	end
end)
