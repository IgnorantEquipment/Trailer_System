--Functions
local module = {}

local RunService = game:GetService("RunService")
local InsertService = game:GetService("InsertService")
local TweenService = game:GetService("TweenService")

function MakeWeld(x, y)
	local weld = Instance.new("Weld")
	weld.Part0 = x
	weld.Part1 = y
	local CJ = CFrame.new(x.Position)
	weld.C0 = x.CFrame:inverse() * CJ
	weld.C1 = y.CFrame:inverse() * CJ
	weld.Parent = x
end

function ModelWeld(a,b)
	if a ~= nil and b ~= nil then
		if a:IsA("BasePart") then
			MakeWeld(b,a,"Weld")
			for i,v in pairs(a:GetChildren()) do
				if v ~= nil then
					ModelWeld(v,b)
				end
			end
		elseif a:IsA("Model") then
			for i,v in pairs(a:GetChildren()) do
				ModelWeld(v,b)
			end
		end
	end
end

function UnAnchor(a)
	if a:IsA("BasePart") then a.Anchored=false  end for i,v in pairs(a:GetChildren()) do UnAnchor(v) end
end

function getParts(model,t,a)
	for i,v in pairs(model:GetChildren()) do
		if v:IsA("BasePart") then table.insert(t,{v,a.CFrame:toObjectSpace(v.CFrame)})
		elseif v:IsA("Model") then getParts(v,t,a)
		end
	end
end

function DReduce(p)
	for i,v in pairs(p:GetChildren()) do
		if v:IsA("BasePart") then
			if v.CustomPhysicalProperties == nil then v.CustomPhysicalProperties = PhysicalProperties.new(v.Material) end
			v.CustomPhysicalProperties = PhysicalProperties.new(
				0,
				0,
				0,
				0,
				0
			)
			v.Massless = false
		end
		DReduce(v)
	end
end

function getMass(p)
	local mass=0
	for i,v in pairs(p:GetChildren()) do
		if v:IsA("BasePart") then
			mass=mass+v:GetMass()
		end
		getMass(v)
	end
end

function Flip(Trailer)
	local Tune = require(Trailer:FindFirstChild("TGNG Trailer Settings"))
	local FlipWait=tick()
	local FlipDB=false
	if (Trailer.Body.Prim.CFrame*CFrame.Angles(math.pi/2,0,0)).lookVector.y > .1 or FlipDB == true then
	else
		wait(3)
		FlipDB=true
		local gyro = Trailer.Body.Prim.Flip
		gyro.MaxTorque = 70 * Tune.Weight
		gyro.AngularVelocity = Vector3.new(75 * Tune.Weight,0,75 * Tune.Weight)
		wait(.2)
		gyro.MaxTorque = 0
		gyro.AngularVelocity = Vector3.new(0,0,0)
		wait(.5)
		FlipDB=false
	end
end

function UpdateLights(Trailer)
	local Lights = Trailer.Body.Lights
	local TandemLights = nil
	
	local markertable = {}
	
	if Trailer:FindFirstChild("Tandem") ~= nil then
		TandemLights = Trailer:FindFirstChild("Tandem").Body.Lights
	end
	
	local function update(prt,col,mat,trn,rng,brt,lon)
		if prt.Name == "ML" and prt.Parent.Name ~= "Parts" or prt.Name == "BL" and prt.Parent.Name ~= "Parts" or prt.Name == "BR" and prt.Parent.Name ~= "Parts" or prt.Name == "BM" and prt.Parent.Name ~= "Parts" or prt.Name == "RI" and prt.Parent.Name ~= "Parts" or prt.Name == "LI" and prt.Parent.Name ~= "Parts" or prt.Name == "PL" and prt.Parent.Name ~= "Parts" then
			local RangeTween = TweenService:Create(prt.L, TweenInfo.new(.2), {Range = rng})
			local BrightTween = TweenService:Create(prt.L, TweenInfo.new(.2), {Brightness = brt})
			RangeTween:Play()
			BrightTween:Play()
			wait()
			RangeTween.Completed:Connect(function()
				prt.L.Enabled = lon
				prt.Material = mat
				prt.BrickColor = col
				if prt.Name == "PL" then
					if lon == true then
						prt.B.Enabled = true
					else
						prt.B.Enabled = false
					end
				end
			end)
		else
			local TranTween = TweenService:Create(prt, TweenInfo.new(.2), {Transparency = trn})
			prt.BrickColor = col
			wait()
			if lon ~= true then
				TranTween:Play()
				TranTween.Completed:Connect(function()
					prt.Material = mat
				end)
			else
				TranTween:Play()
				prt.Material = mat
			end
		end
	end
	if Lights:FindFirstChild("Markers") ~= nil then
		for i,m in pairs(Lights.Markers:GetChildren()) do
			if not table.find(markertable,m) then
				table.insert(markertable,m)
			end
		end
	end
	if Trailer:FindFirstChild("Tandem") ~= nil then
		if TandemLights:FindFirstChild("Markers") ~= nil then
			for i,m in pairs(TandemLights.Markers:GetChildren()) do
				if not table.find(markertable,m) then
					table.insert(markertable,m)
				end
			end
		end
	end
	update(Lights.BL,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
	update(Lights.BR,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
	update(Lights.Parts.R,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
	update(Lights.PL,BrickColor.new("Dark stone grey"),Enum.Material.SmoothPlastic,0,0,0,false)
	update(Lights.LI,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
	update(Lights.Parts.LI,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
	update(Lights.RI,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
	update(Lights.Parts.RI,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
	update(Lights.Parts.M,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
	if Lights:FindFirstChild("RM") then
		update(Lights.RM,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
		update(Lights.Parts.RM,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
	end
	for i,m in pairs(markertable) do
		update(m,m.BrickColor,Enum.Material.SmoothPlastic,1,0,0,false)
	end
	for i,p in pairs(Lights.Parts:GetChildren()) do
		update(p,p.BrickColor,Enum.Material.SmoothPlastic,1,0,0,false)
	end
	if Trailer:FindFirstChild("Tandem") ~= nil then
		update(TandemLights.BL,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
		update(TandemLights.BR,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
		update(TandemLights.Parts.R,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
		update(TandemLights.PL,BrickColor.new("Dark stone grey"),Enum.Material.SmoothPlastic,0,0,0,false)
		update(TandemLights.LI,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
		update(TandemLights.Parts.LI,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
		update(TandemLights.RI,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
		update(TandemLights.Parts.RI,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
		update(TandemLights.Parts.M,BrickColor.new("Neon orange"),Enum.Material.SmoothPlastic,1,0,0,false)
		if TandemLights:FindFirstChild("RM") then
			update(TandemLights.RM,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
			update(TandemLights.Parts.RM,BrickColor.new("Burgundy"),Enum.Material.SmoothPlastic,1,0,0,false)
		end
		for i,tp in pairs(TandemLights.Parts:GetChildren()) do
			update(tp,tp.BrickColor,Enum.Material.SmoothPlastic,1,0,0,false)
		end
	end
end

function CreateSuspension(Trailer)
	local Tune = require(Trailer:FindFirstChild("TGNG Trailer Settings"))
	local Rep = script:WaitForChild("R")
	local weightScaling = 1/50
	
	for _,v in pairs(Trailer.Wheels:GetChildren()) do
		--Apply Wheel Density
		if v:IsA("BasePart") then
			if v.CustomPhysicalProperties == nil then v.CustomPhysicalProperties = PhysicalProperties.new(v.Material) end
			v.CustomPhysicalProperties = PhysicalProperties.new(Tune.WheelDensity,Tune.WheelFriction,1,1,1)
		end
	end
	
	--Calculate Weight Distribution
	local centerF = Vector3.new()
	local centerR = Vector3.new()
	local countF = 0
	local countR = 0

	for i,v in pairs(Trailer.Wheels:GetChildren()) do
		if v.Name=="FL" or v.Name=="FR" then
			centerF = centerF+v.CFrame.p
			countF = countF+1
		else
			centerR = centerR+v.CFrame.p
			countR = countR+1
		end
	end
	centerF = centerF/countF
	centerR = centerR/countR
	local center = centerR:Lerp(centerF, 150/100)
	local orientation, size = Trailer.Body:GetBoundingBox()
	local Primary = Instance.new("Part")
	Primary.Anchored = true
	Primary.CanCollide = false
	Primary.Transparency = 1
	Primary.Name = "Prim"
	Primary.CFrame = orientation
	Primary.Parent = Trailer.Body
	Trailer.PrimaryPart = Primary

	--Add Stabilization Gyro
	local gyro=Instance.new("BodyGyro",Primary)
	gyro.Name="Stabilizer"
	gyro.MaxTorque=Vector3.new(1,0,1)
	gyro.P=1
	gyro.D=Tune.GyroDamp
	
	--Create Weight Brick
	local weightB = Instance.new("Part",Trailer.Body)
	weightB.Name = "#Weight"
	weightB.Anchored = true
	weightB.CanCollide = false
	weightB.BrickColor = BrickColor.new("Really black")
	weightB.TopSurface = Enum.SurfaceType.Smooth
	weightB.BottomSurface = Enum.SurfaceType.Smooth
	weightB.Transparency = 1
	weightB.Size = size/2
	weightB.CustomPhysicalProperties = PhysicalProperties.new(((Tune.Weight*weightScaling))/(weightB.Size.x*weightB.Size.y*weightB.Size.z),0,0,0,0)
	weightB.CFrame=orientation

	local AxleModels = Instance.new("Model")
	AxleModels.Name = "Axles"
	AxleModels.Parent = Trailer.Misc

	local H = Rep:FindFirstChild("Hold"):Clone()
	H.Size = Vector3.new(1,1,1)
	H.Name = "WH"
	H.CanCollide = false
	H.Transparency = 1
	
	if Trailer.Body:FindFirstChild("RearHitch") ~= nil then
		local RearHitch = Trailer.Body:FindFirstChild("RearHitch")
		local A2 = Instance.new("Attachment", RearHitch)
		A2.Name = "HitchA2"
	end
	
	for _,Wheel in pairs(Trailer.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			local WH = H:Clone()
			WH.Parent = Wheel
			WH.CFrame = Wheel.CFrame
			if Wheel.Name=="FL" or Wheel.Name=="FR" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(-math.pi/2,-math.pi/2,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(-math.pi/2,-math.pi/2,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Trailer.Wheels.FR.CFrame:ToObjectSpace(Trailer.Wheels.FL.CFrame)).Position.Magnitude

				if Wheel.Name == "FR" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Trailer.Wheels.FR.CFrame:Lerp(Trailer.Wheels.FL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Trailer.Wheels.FL.WH.Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Trailer.Wheels.FR.WH.Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Trailer.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Trailer.Wheels.FR.CFrame:Lerp(Trailer.Wheels.FL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
	for _,Wheel in pairs(Trailer.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			if Wheel.Name=="L" or Wheel.Name=="R" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Trailer.Wheels.R.CFrame:ToObjectSpace(Trailer.Wheels.L.CFrame)).Position.Magnitude

				if Wheel.Name == "R" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Trailer.Wheels.R.CFrame:Lerp(Trailer.Wheels.L.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Trailer.Wheels.L.WH.Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Trailer.Wheels.R.WH.Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Trailer.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Trailer.Wheels.R.CFrame:Lerp(Trailer.Wheels.L.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame * CFrame.Angles(0, 0, 180)
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
	for _,Wheel in pairs(Trailer.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			if Wheel.Name=="RL" or Wheel.Name=="RR" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Trailer.Wheels.RR.CFrame:ToObjectSpace(Trailer.Wheels.RL.CFrame)).Position.Magnitude

				if Wheel.Name == "RR" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Trailer.Wheels.RR.CFrame:Lerp(Trailer.Wheels.RL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Trailer.Wheels.RL.WH.Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Trailer.Wheels.RR.WH.Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Trailer.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Trailer.Wheels.RR.CFrame:Lerp(Trailer.Wheels.RL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame * CFrame.Angles(0, 0, 180)
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
end

function SetupTandem(Trailer, Tandem)
	local Tune = require(Trailer:FindFirstChild("TGNG Trailer Settings"))
	local Rep = script:WaitForChild("R")
	local weightScaling = 1/50

	for _,v in pairs(Tandem.Wheels:GetChildren()) do
		--Apply Wheel Density
		if v:IsA("BasePart") then
			if v.CustomPhysicalProperties == nil then v.CustomPhysicalProperties = PhysicalProperties.new(v.Material) end
			v.CustomPhysicalProperties = PhysicalProperties.new(Tune.WheelDensity,Tune.WheelFriction,1,1,1)
		end
	end

	--Calculate Weight Distribution
	local centerF = Vector3.new()
	local centerR = Vector3.new()
	local countF = 0
	local countR = 0

	for i,v in pairs(Tandem.Wheels:GetChildren()) do
		if v.Name=="FL" or v.Name=="FR" then
			centerF = centerF+v.CFrame.p
			countF = countF+1
		else
			centerR = centerR+v.CFrame.p
			countR = countR+1
		end
	end
	centerF = centerF/countF
	centerR = centerR/countR
	local center = centerR:Lerp(centerF, 100/100)
	local orientation, size = Tandem.Body:GetBoundingBox()
	local Primary = Instance.new("Part")
	Primary.Anchored = true
	Primary.CanCollide = false
	Primary.Transparency = 1
	Primary.Name = "Prim"
	Primary.CFrame = orientation
	Primary.Parent = Tandem.Body
	Tandem.PrimaryPart = Primary

	--Add Stabilization Gyro
	local gyro=Instance.new("BodyGyro",Primary)
	gyro.Name="Stabilizer"
	gyro.MaxTorque=Vector3.new(1,0,1)
	gyro.P=1
	gyro.D=Tune.GyroDamp

	--Create Weight Brick
	local weightB = Instance.new("Part",Tandem.Body)
	weightB.Name = "#Weight"
	weightB.Anchored = true
	weightB.CanCollide = false
	weightB.BrickColor = BrickColor.new("Really black")
	weightB.TopSurface = Enum.SurfaceType.Smooth
	weightB.BottomSurface = Enum.SurfaceType.Smooth
	weightB.Transparency = 1
	weightB.Size = size/2
	weightB.CustomPhysicalProperties = PhysicalProperties.new(((Tune.DoubleWeight*weightScaling))/(weightB.Size.x*weightB.Size.y*weightB.Size.z),0,0,0,0)
	weightB.CFrame=orientation

	local AxleModels = Instance.new("Model")
	AxleModels.Name = "Axles"
	AxleModels.Parent = Tandem.Misc

	local H = Rep:FindFirstChild("Hold"):Clone()
	H.Size = Vector3.new(1,1,1)
	H.Name = "WH"
	H.CanCollide = false
	H.Transparency = 1
	
	local TandemHitch = Tandem.Body:FindFirstChild("Hitch")
	local Coupler = Instance.new("BallSocketConstraint",TandemHitch)
	Coupler.Name = "Coupler"
	local A1 = Instance.new("Attachment", TandemHitch)
	A1.Name = "HitchA1"
	wait()
	local A2 = Tandem.Dolly.Body.RearHitch:FindFirstChild("HitchA2")
	Coupler.Attachment0 = A1
	Coupler.Attachment1 = A2
	local TrChainL
	local TrChainR
	for i,prt in pairs(Tandem.Dolly.Body:GetChildren()) do
		if prt.Name == "Chain_L" and (Tandem.Dolly.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrChainL = prt
		end
		if prt.Name == "Chain_R" and (Tandem.Dolly.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrChainR = prt
		end
	end
	if Tune.SafetyChains then
		if Tandem.Body:FindFirstChild("Chain_L") ~= nil and Tandem.Body:FindFirstChild("Chain_R") ~= nil then
			if TrChainL ~= nil and TrChainR ~= nil then
				local ChainL = Tandem.Body:FindFirstChild("Chain_L")
				local ChainR = Tandem.Body:FindFirstChild("Chain_R")
				local CL_A0 = Instance.new("Attachment",ChainL)
				local CL_A1 = Instance.new("Attachment",TrChainL)
				CL_A0.Name = "ChainA0"
				CL_A1.Name = "ChainA1"
				local CR_A0 = Instance.new("Attachment",ChainR)
				local CR_A1 = Instance.new("Attachment",TrChainR)
				CR_A0.Name = "ChainA0"
				CR_A1.Name = "ChainA1"
				local RopeL = Instance.new("RopeConstraint",ChainL)
				local RopeR = Instance.new("RopeConstraint",ChainR)
				RopeL.Name = "Rope"
				RopeL.Attachment0 = CL_A0
				RopeL.Attachment1 = CL_A1
				RopeL.Visible = true
				RopeL.Color = BrickColor.new(Tune.ChainColor)
				RopeL.Thickness = Tune.ChainThickness
				RopeR.Name = "Rope"
				RopeR.Attachment0 = CR_A0
				RopeR.Attachment1 = CR_A1
				RopeR.Visible = true
				RopeR.Color = BrickColor.new(Tune.ChainColor)
				RopeR.Thickness = Tune.ChainThickness
				RopeL.Length = Tune.ChainLength
				RopeR.Length = Tune.ChainLength
			end
		end
	end
	local TrCable
	for i,prt in pairs(Tandem.Dolly.Body:GetChildren()) do
		if prt.Name == "ElectricCable" and (Tandem.Dolly.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrCable = prt
		end
	end
	if Tune.ElectricCable then
		if Tandem.Body:FindFirstChild("ElectricCable") ~= nil then
			if TrCable ~= nil then
				local Cable = Tandem.Body:FindFirstChild("ElectricCable")
				local C_A0 = Instance.new("Attachment",Cable)
				local C_A1 = Instance.new("Attachment",TrCable)
				C_A0.Name = "CableA0"
				C_A1.Name = "CableA1"
				local Spring = Instance.new("SpringConstraint",Cable)
				Spring.Name = "Spring"
				Spring.Attachment0 = C_A0
				Spring.Attachment1 = C_A1
				Spring.Visible = true
				Spring.Color = BrickColor.new(Tune.CableColor)
				Spring.Thickness = Tune.CableThickness
				Spring.Radius = Tune.CableRadius
				Spring.Coils = 8
				Spring.Damping = 0
				Spring.Stiffness = 0
				Spring.FreeLength = 25
			end
		end
	end
	local TrAirL
	local TrAirR
	for i,prt in pairs(Tandem.Dolly.Body:GetChildren()) do
		if prt.Name == "Air_L" and (Tandem.Dolly.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrAirL = prt
		end
		if prt.Name == "Air_R" and (Tandem.Dolly.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrAirR = prt
		end
	end
	if Tune.AirHoses then
		if Tandem.Body:FindFirstChild("Air_L") ~= nil and Tandem.Body:FindFirstChild("Air_R") ~= nil then
			if TrAirL ~= nil and TrAirR ~= nil then
				local AirL = Tandem.Body:FindFirstChild("Air_L")
				local AirR = Tandem.Body:FindFirstChild("Air_R")
				local AL_A0 = Instance.new("Attachment",AirL)
				local AL_A1 = Instance.new("Attachment",TrAirL)
				AL_A0.Name = "HoseA0"
				AL_A1.Name = "HoseA1"
				local AR_A0 = Instance.new("Attachment",AirR)
				local AR_A1 = Instance.new("Attachment",TrAirR)
				AR_A0.Name = "HoseA0"
				AR_A1.Name = "HoseA1"
				local SpringL = Instance.new("SpringConstraint",AirL)
				local SpringR = Instance.new("SpringConstraint",AirR)
				SpringL.Name = "Spring"
				SpringL.Attachment0 = AL_A0
				SpringL.Attachment1 = AL_A1
				SpringL.Visible = true
				SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
				SpringL.Thickness = Tune.HoseThickness
				SpringL.Radius = Tune.HoseRadius
				SpringL.Coils = 8
				SpringL.Damping = 0
				SpringL.Stiffness = 0
				SpringL.FreeLength = 25
				SpringR.Name = "Spring"
				SpringR.Attachment0 = AR_A0
				SpringR.Attachment1 = AR_A1
				SpringR.Visible = true
				SpringR.Color = BrickColor.new(Tune.HoseRightColor)
				SpringR.Thickness = Tune.HoseThickness
				SpringR.Radius = Tune.HoseRadius
				SpringR.Coils = 8
				SpringR.Damping = 0
				SpringR.Stiffness = 0
				SpringR.FreeLength = 25
			end
		end
	end
	
	for _,Wheel in pairs(Tandem.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			local WH = H:Clone()
			WH.Parent = Wheel
			WH.CFrame = Wheel.CFrame
		end
	end
	
	wait(Tune.LoadDelay)

	for _,Wheel in pairs(Tandem.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			if Wheel.Name=="FL" or Wheel.Name=="FR" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(-math.pi/2,-math.pi/2,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(-math.pi/2,-math.pi/2,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Tandem.Wheels.FR.CFrame:ToObjectSpace(Tandem.Wheels.FL.CFrame)).Position.Magnitude

				if Wheel.Name == "FR" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Tandem.Wheels.FR.CFrame:Lerp(Tandem.Wheels.FL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Tandem.Wheels.FL.WH.Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Tandem.Wheels.FR.WH.Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Tandem.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Tandem.Wheels.FR.CFrame:Lerp(Tandem.Wheels.FL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
	for _,Wheel in pairs(Tandem.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			if Wheel.Name=="L" or Wheel.Name=="R" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Tandem.Wheels.R.CFrame:ToObjectSpace(Tandem.Wheels.L.CFrame)).Position.Magnitude

				if Wheel.Name == "R" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Tandem.Wheels.R.CFrame:Lerp(Tandem.Wheels.L.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Tandem.Wheels.L.WH.Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Tandem.Wheels.R.WH.Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Tandem.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Tandem.Wheels.R.CFrame:Lerp(Tandem.Wheels.L.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame * CFrame.Angles(0, 0, 180)
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
	for _,Wheel in pairs(Tandem.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			if Wheel.Name=="RL" or Wheel.Name=="RR" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Tandem.Wheels.RR.CFrame:ToObjectSpace(Tandem.Wheels.RL.CFrame)).Position.Magnitude

				if Wheel.Name == "RR" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Tandem.Wheels.RR.CFrame:Lerp(Tandem.Wheels.RL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Tandem.Wheels.RL.WH.Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Tandem.Wheels.RR.WH.Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Tandem.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Tandem.Wheels.RR.CFrame:Lerp(Tandem.Wheels.RL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame * CFrame.Angles(0, 0, 180)
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
end

function SetupDolly(Trailer, Dolly)
	local Tune = require(Trailer:FindFirstChild("TGNG Trailer Settings"))
	local Rep = script:WaitForChild("R")
	local weightScaling = 1/50

	for _,v in pairs(Dolly.Wheels:GetChildren()) do
		--Apply Wheel Density
		if v:IsA("BasePart") then
			if v.CustomPhysicalProperties == nil then v.CustomPhysicalProperties = PhysicalProperties.new(v.Material) end
			v.CustomPhysicalProperties = PhysicalProperties.new(Tune.WheelDensity,Tune.WheelFriction,1,1,1)
		end
	end

	--Calculate Weight Distribution
	local centerF = Vector3.new()
	local centerR = Vector3.new()
	local countF = 0
	local countR = 0

	for i,v in pairs(Dolly.Wheels:GetChildren()) do
		if v.Name=="FL" or v.Name=="FR" then
			centerF = centerF+v.CFrame.p
			countF = countF+1
		else
			centerR = centerR+v.CFrame.p
			countR = countR+1
		end
	end
	centerF = centerF/countF
	centerR = centerR/countR
	local center = centerR:Lerp(centerF, 150/100)
	local orientation, size = Dolly.Body:GetBoundingBox()
	local Primary = Instance.new("Part")
	Primary.Anchored = true
	Primary.CanCollide = false
	Primary.Transparency = 1
	Primary.Name = "Prim"
	Primary.CFrame = orientation
	Primary.Parent = Dolly.Body
	Dolly.PrimaryPart = Primary

	--Add Stabilization Gyro
	local gyro=Instance.new("BodyGyro",Primary)
	gyro.Name="Stabilizer"
	gyro.MaxTorque=Vector3.new(1,0,1)
	gyro.P=1
	gyro.D=Tune.GyroDamp

	--Create Weight Brick
	local weightB = Instance.new("Part",Dolly.Body)
	weightB.Name = "#Weight"
	weightB.Anchored = true
	weightB.CanCollide = false
	weightB.BrickColor = BrickColor.new("Really black")
	weightB.TopSurface = Enum.SurfaceType.Smooth
	weightB.BottomSurface = Enum.SurfaceType.Smooth
	weightB.Transparency = 1
	weightB.Size = size/2
	weightB.CustomPhysicalProperties = PhysicalProperties.new(((Tune.DollyWeight*weightScaling))/(weightB.Size.x*weightB.Size.y*weightB.Size.z),0,0,0,0)
	weightB.CFrame=orientation

	local AxleModels = Instance.new("Model")
	AxleModels.Name = "Axles"
	AxleModels.Parent = Dolly.Misc

	local H = Rep:FindFirstChild("Hold"):Clone()
	H.Size = Vector3.new(1,1,1)
	H.Name = "WH"
	H.CanCollide = false
	H.Transparency = 1
	
	local DollyHitch = Dolly.Body:FindFirstChild("Hitch")
	local Coupler = Instance.new("BallSocketConstraint",DollyHitch)
	Coupler.Name = "Coupler"
	local A1 = Instance.new("Attachment", DollyHitch)
	A1.Name = "HitchA1"
	local A2 = Trailer.Body.RearHitch:FindFirstChild("HitchA2")
	Coupler.Attachment0 = A1
	Coupler.Attachment1 = A2
	local TrChainL
	local TrChainR
	for i,prt in pairs(Trailer.Body:GetChildren()) do
		if prt.Name == "Chain_L" and (Trailer.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrChainL = prt
		end
		if prt.Name == "Chain_R" and (Trailer.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrChainR = prt
		end
	end
	local ChainL
	local ChainR
	for i,prt2 in pairs(Dolly.Body:GetChildren()) do
		if prt2.Name == "Chain_L" and (Dolly.Body.Hitch.Position - prt2.Position).Magnitude <= 6 then
			ChainL = prt2
		end
		if prt2.Name == "Chain_R" and (Dolly.Body.Hitch.Position - prt2.Position).Magnitude <= 6 then
			ChainR = prt2
		end
	end
	if Tune.SafetyChains then
		if ChainL ~= nil and ChainR ~= nil then
			if TrChainL ~= nil and TrChainR ~= nil then
				local CL_A0 = Instance.new("Attachment",ChainL)
				local CL_A1 = Instance.new("Attachment",TrChainL)
				CL_A0.Name = "ChainA0"
				CL_A1.Name = "ChainA1"
				local CR_A0 = Instance.new("Attachment",ChainR)
				local CR_A1 = Instance.new("Attachment",TrChainR)
				CR_A0.Name = "ChainA0"
				CR_A1.Name = "ChainA1"
				local RopeL = Instance.new("RopeConstraint",ChainL)
				local RopeR = Instance.new("RopeConstraint",ChainR)
				RopeL.Name = "Rope"
				RopeL.Attachment0 = CL_A0
				RopeL.Attachment1 = CL_A1
				RopeL.Visible = true
				RopeL.Color = BrickColor.new(Tune.ChainColor)
				RopeL.Thickness = Tune.ChainThickness
				RopeR.Name = "Rope"
				RopeR.Attachment0 = CR_A0
				RopeR.Attachment1 = CR_A1
				RopeR.Visible = true
				RopeR.Color = BrickColor.new(Tune.ChainColor)
				RopeR.Thickness = Tune.ChainThickness
				RopeL.Length = Tune.ChainLength
				RopeR.Length = Tune.ChainLength
			end
		end
	end
	local TrCable
	for i,prt in pairs(Trailer.Body:GetChildren()) do
		if prt.Name == "ElectricCable" and (Trailer.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrCable = prt
		end
	end
	local Cable
	for i,prt in pairs(Dolly.Body:GetChildren()) do
		if prt.Name == "ElectricCable" and (Dolly.Body.Hitch.Position - prt.Position).Magnitude <= 6 then
			Cable = prt
		end
	end
	if Tune.ElectricCable then
		if Cable ~= nil then
			if TrCable ~= nil then
				local C_A0 = Instance.new("Attachment",Cable)
				local C_A1 = Instance.new("Attachment",TrCable)
				C_A0.Name = "CableA0"
				C_A1.Name = "CableA1"
				local Spring = Instance.new("SpringConstraint",Cable)
				Spring.Name = "Spring"
				Spring.Attachment0 = C_A0
				Spring.Attachment1 = C_A1
				Spring.Visible = true
				Spring.Color = BrickColor.new(Tune.CableColor)
				Spring.Thickness = Tune.CableThickness
				Spring.Radius = Tune.CableRadius
				Spring.Coils = 8
				Spring.Damping = 0
				Spring.Stiffness = 0
				Spring.FreeLength = 25
			end
		end
	end
	local TrAirL
	local TrAirR
	for i,prt in pairs(Trailer.Body:GetChildren()) do
		if prt.Name == "Air_L" and (Trailer.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrAirL = prt
		end
		if prt.Name == "Air_R" and (Trailer.Body.RearHitch.Position - prt.Position).Magnitude <= 6 then
			TrAirR = prt
		end
	end
	local AirL
	local AirR
	for i,prt2 in pairs(Dolly.Body:GetChildren()) do
		if prt2.Name == "Air_L" and (Dolly.Body.Hitch.Position - prt2.Position).Magnitude <= 6 then
			AirL = prt2
		end
		if prt2.Name == "Air_R" and (Dolly.Body.Hitch.Position - prt2.Position).Magnitude <= 6 then
			AirR = prt2
		end
	end
	if Tune.AirHoses then
		if AirL ~= nil and AirR ~= nil then
			if TrAirL ~= nil and TrAirR ~= nil then
				local AL_A0 = Instance.new("Attachment",AirL)
				local AL_A1 = Instance.new("Attachment",TrAirL)
				AL_A0.Name = "HoseA0"
				AL_A1.Name = "HoseA1"
				local AR_A0 = Instance.new("Attachment",AirR)
				local AR_A1 = Instance.new("Attachment",TrAirR)
				AR_A0.Name = "HoseA0"
				AR_A1.Name = "HoseA1"
				local SpringL = Instance.new("SpringConstraint",AirL)
				local SpringR = Instance.new("SpringConstraint",AirR)
				SpringL.Name = "Spring"
				SpringL.Attachment0 = AL_A0
				SpringL.Attachment1 = AL_A1
				SpringL.Visible = true
				SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
				SpringL.Thickness = Tune.HoseThickness
				SpringL.Radius = Tune.HoseRadius
				SpringL.Coils = 8
				SpringL.Damping = 0
				SpringL.Stiffness = 0
				SpringL.FreeLength = 25
				SpringR.Name = "Spring"
				SpringR.Attachment0 = AR_A0
				SpringR.Attachment1 = AR_A1
				SpringR.Visible = true
				SpringR.Color = BrickColor.new(Tune.HoseRightColor)
				SpringR.Thickness = Tune.HoseThickness
				SpringR.Radius = Tune.HoseRadius
				SpringR.Coils = 8
				SpringR.Damping = 0
				SpringR.Stiffness = 0
				SpringR.FreeLength = 25
			end
		end
	end
	
	local DollyRearHitch = Dolly.Body:FindFirstChild("RearHitch")
	local RA2 = Instance.new("Attachment", DollyRearHitch)
	RA2.Name = "HitchA2"
	
	for _,Wheel in pairs(Dolly.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			local WH = H:Clone()
			WH.Parent = Wheel
			WH.CFrame = Wheel.CFrame
		end
	end
	wait(Tune.LoadDelay)
	for _,Wheel in pairs(Dolly.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			if Wheel.Name=="FL" or Wheel.Name=="FR" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(-math.pi/2,-math.pi/2,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(-math.pi/2,-math.pi/2,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Dolly.Wheels.FR.CFrame:ToObjectSpace(Dolly.Wheels.FL.CFrame)).Position.Magnitude

				if Wheel.Name == "FR" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Dolly.Wheels.FR.CFrame:Lerp(Dolly.Wheels.FL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Dolly.Wheels.FL:WaitForChild("WH").Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Dolly.Wheels.FR:WaitForChild("WH").Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Dolly.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Dolly.Wheels.FR.CFrame:Lerp(Dolly.Wheels.FL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
	for _,Wheel in pairs(Dolly.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			if Wheel.Name=="L" or Wheel.Name=="R" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Dolly.Wheels.R.CFrame:ToObjectSpace(Dolly.Wheels.L.CFrame)).Position.Magnitude

				if Wheel.Name == "R" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Dolly.Wheels.R.CFrame:Lerp(Dolly.Wheels.L.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Dolly.Wheels.L.WH.Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Dolly.Wheels.R.WH.Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Dolly.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Dolly.Wheels.R.CFrame:Lerp(Dolly.Wheels.L.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame * CFrame.Angles(0, 0, 180)
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
	for _,Wheel in pairs(Dolly.Wheels:GetChildren()) do
		if Wheel:IsA("BasePart") then
			if Wheel.Name=="RL" or Wheel.Name=="RR" then
				--Create Axle
				local axle = Rep:FindFirstChild("Axle"):Clone()
				axle.Name = "#A"
				axle.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				axle.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				axle.Transparency = 1

				local hold = Rep:FindFirstChild("SpringHold"):Clone()
				hold.Name = "#SH"
				hold.CFrame = (Wheel.CFrame*CFrame.new(0,1,0))*CFrame.Angles(0,0,0)
				hold.CustomPhysicalProperties = PhysicalProperties.new(.1,0,0,0,0)
				hold.Transparency = 1

				local WheelDifference = (Dolly.Wheels.RR.CFrame:ToObjectSpace(Dolly.Wheels.RL.CFrame)).Position.Magnitude

				if Wheel.Name == "RR" then
					local Axle = axle:Clone() 
					Axle.Anchored = true
					Axle.Parent = AxleModels
					Axle.Name = "#A"
					Axle.Size = Vector3.new(WheelDifference,1,1)
					Axle.CFrame = Dolly.Wheels.RR.CFrame:Lerp(Dolly.Wheels.RL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 0, 0)
					Axle.Massless = true
					Axle.Rod.Visible = Tune.AxleVisible
					Axle.Rod.Color = BrickColor.new(Tune.AxleColor)
					Axle.Rod.Thickness = Tune.AxleThickness
					local AxAttachment0 = Axle.AxAttachmentL
					AxAttachment0.Position = Vector3.new(Axle.Size.X/2,0,0)
					local AxAttachment1 = Axle.AxAttachmentR
					AxAttachment1.Position = Vector3.new(-Axle.Size.X/2,0,0)
					local LHinge = Instance.new("HingeConstraint")
					LHinge.Name = "#LH"
					LHinge.Parent = Axle
					LHinge.Attachment0 = AxAttachment0
					LHinge.Attachment1 = Dolly.Wheels.RL.WH.Attachment
					local RHinge = Instance.new("HingeConstraint")
					RHinge.Name = "#RH"
					RHinge.Parent = Axle
					RHinge.Attachment0 = AxAttachment1
					RHinge.Attachment1 = Dolly.Wheels.RR.WH.Attachment

					local SH = hold:Clone()
					SH.Anchored = true
					SH.Parent = Dolly.Body
					SH.Name = "#SH"
					SH.Size = Vector3.new(WheelDifference,1,1)
					SH.CFrame = Dolly.Wheels.RR.CFrame:Lerp(Dolly.Wheels.RL.CFrame, 0.5)*CFrame.new(((WheelDifference)*((50-50)/100)), 3, 0)
					SH.Massless = true

					local AH = Rep:FindFirstChild("AH"):Clone()
					AH.Transparency = 1
					AH.Anchored = true
					AH.Parent = AxleModels
					AH.Name = "#S"
					AH.CFrame = Axle.CFrame * CFrame.Angles(0, 0, 180)
					AH.Massless = true

					local AHHinge = Instance.new("HingeConstraint")
					AHHinge.Parent = AH
					AHHinge.Attachment0 = AH:FindFirstChild("HAttachment")
					AHHinge.Attachment1 = Axle:FindFirstChild("AHAttachment")
					Axle.Pris.Attachment0 = AH:FindFirstChild("PAttachment")
					Axle.Pris.Attachment1 = SH:FindFirstChild("AHAttachment")

					local SAAttachment0 = Axle.SAttachmentL
					SAAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SAAttachment1 = Axle.SAttachmentR
					SAAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local SBAttachment0 = SH.SAttachmentL
					SBAttachment0.Position = Vector3.new(WheelDifference-7,0,0)
					local SBAttachment1 = SH.SAttachmentR
					SBAttachment1.Position = Vector3.new(-WheelDifference+7,0,0)

					local LSpring = Instance.new("SpringConstraint")
					LSpring.LimitsEnabled = true
					LSpring.Name = "#LS"
					LSpring.Parent = Axle
					LSpring.Attachment0 = SAAttachment0
					LSpring.Attachment1 = SBAttachment0
					LSpring.Damping = Tune.SpringDamping
					LSpring.Stiffness = Tune.SpringStiffness
					LSpring.FreeLength = Tune.SpringLength+1
					LSpring.MaxLength = Tune.SpringMaxLength
					LSpring.MinLength = Tune.SpringMinLength
					LSpring.Visible = Tune.SpringVisible
					LSpring.Radius = Tune.SpringRadius
					LSpring.Thickness = Tune.SpringThickness
					LSpring.Color = BrickColor.new(Tune.SpringColor)
					LSpring.Coils = Tune.SpringCoilCount
					local RSpring = Instance.new("SpringConstraint")
					RSpring.LimitsEnabled = true
					RSpring.Name = "#RS"
					RSpring.Parent = Axle
					RSpring.Attachment0 = SAAttachment1
					RSpring.Attachment1 = SBAttachment1
					RSpring.Damping = Tune.SpringDamping
					RSpring.Stiffness = Tune.SpringStiffness
					RSpring.FreeLength = Tune.SpringLength+1
					RSpring.MaxLength = Tune.SpringMaxLength
					RSpring.MinLength = Tune.SpringMinLength
					RSpring.Visible = Tune.SpringVisible
					RSpring.Radius = Tune.SpringRadius
					RSpring.Thickness = Tune.SpringThickness
					RSpring.Color = BrickColor.new(Tune.SpringColor)
					RSpring.Coils = Tune.SpringCoilCount
				end
				ModelWeld(Wheel,Wheel.WH)
				if Wheel:FindFirstChild("Parts")~=nil then
					ModelWeld(Wheel.Parts,Wheel)
				end
				if Wheel:FindFirstChild("Fixed")~=nil then
					ModelWeld(Wheel.Fixed,Wheel)
				end
			end
		end
	end
end

function CreateAccessories(Trailer)
	local Rep = script:WaitForChild("R")
	local Whitelist = require(8270037974)
	local UserIds = Whitelist["UserIds"]
	
	if Trailer.Name == "Tandem" then
		local Tune = require(Trailer.Parent:FindFirstChild("TGNG Trailer Settings"))
		local bHitchedSound = nil;
		local bUnHitchedSound = nil;
		local bDoubleHitchPart = nil;
		local bHitch = nil;
		local bHitchEvent = nil;

		local bJackUp = false;
		local bRampDw = false;
		
		if Tune.DoubleHitchEnabled then
			for i,v in pairs(Trailer.Body:GetChildren()) do
				if v:IsA("BasePart") and v.Name == "Hitch" then
					bDoubleHitchPart = v
				end
			end
			bHitch = bDoubleHitchPart:FindFirstChild("Coupler")
			local HitchEvent = Rep:FindFirstChild("HitchEvent"):Clone()
			HitchEvent.Parent = Trailer.Body
			bHitchEvent = HitchEvent
			if Tune.HitchSoundType == "Custom" then
				local HitchedSound = Instance.new("Sound",bDoubleHitchPart)
				HitchedSound.SoundId = "rbxassetid://" .. Tune.HitchedSoundId
				HitchedSound.Name = "HitchedSound"
				HitchedSound.Looped = false
				HitchedSound.Volume = Tune.SoundVolume
				HitchedSound.RollOffMinDistance = Tune.SoundMinDistance
				HitchedSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local UnHitchedSound = Instance.new("Sound",bDoubleHitchPart)
				UnHitchedSound.SoundId = "rbxassetid://" .. Tune.UnHitchedSoundId
				UnHitchedSound.Name = "UnHitchedSound"
				UnHitchedSound.Looped = false
				UnHitchedSound.Volume = Tune.SoundVolume
				UnHitchedSound.RollOffMinDistance = Tune.SoundMinDistance
				UnHitchedSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bHitchedSound = HitchedSound
				bUnHitchedSound = UnHitchedSound
			else
				local HitchedSound = Instance.new("Sound",bDoubleHitchPart)
				HitchedSound.SoundId = "rbxassetid://9066107052"
				HitchedSound.Name = "HitchedSound"
				HitchedSound.Looped = false
				HitchedSound.Volume = Tune.SoundVolume
				HitchedSound.RollOffMinDistance = Tune.SoundMinDistance
				HitchedSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local UnHitchedSound = Instance.new("Sound",bDoubleHitchPart)
				UnHitchedSound.SoundId = "rbxassetid://8589487194"
				UnHitchedSound.Name = "UnHitchedSound"
				UnHitchedSound.Looped = false
				UnHitchedSound.Volume = Tune.SoundVolume
				UnHitchedSound.RollOffMinDistance = Tune.SoundMinDistance
				UnHitchedSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bHitchedSound = HitchedSound
				bUnHitchedSound = UnHitchedSound
			end
		end

		local bJackUpSound = nil;
		local bJackDownSound = nil;
		local bJRoot = nil;
		if Tune.DoubleJackEnabled then
			local Jack = Trailer.Body:FindFirstChild("Jack") or Trailer.Body:FindFirstChild("Jacks") or Trailer.Body:FindFirstChild("Leg") or Trailer.Body:FindFirstChild("Legs") or Trailer.Misc:FindFirstChild("Jack") or Trailer.Misc:FindFirstChild("Jacks") or Trailer.Misc:FindFirstChild("Leg") or Trailer.Misc:FindFirstChild("Legs")
			if Jack:IsA("BasePart") then local JackModel = Instance.new("Model",Trailer.Misc) JackModel.Name = "Jack" Jack.Parent = JackModel Jack = JackModel else Jack.Parent = Trailer.Misc Jack.Name = "Jack" end
			local JRoot = Instance.new("Part")
			JRoot.Size = Vector3.new(1,1,1)
			JRoot.CanCollide = false
			JRoot.Transparency = 1
			JRoot.Name = "Root"
			bJRoot = JRoot
			local orientation, size = Jack:GetBoundingBox()
			JRoot.CFrame = orientation
			JRoot.Parent = Trailer.Misc.Jack
			local JHold = JRoot:Clone()
			JHold.Name = "LHold"
			JHold.Parent = Trailer.Body
			local Weld = Instance.new("Weld")
			Weld.Name = "Pos"
			Weld.Parent = JRoot
			Weld.Part0 = JRoot
			Weld.Part1 = JHold
			ModelWeld(Trailer.Misc.Jack,JRoot)
			if Tune.JackSoundType == "Custom" then
				local JackUpSound = Instance.new("Sound",JRoot)
				JackUpSound.SoundId = "rbxassetid://" .. Tune.JackUpSoundId
				JackUpSound.Name = "JackUpSound"
				JackUpSound.Looped = false
				JackUpSound.Volume = Tune.SoundVolume
				JackUpSound.RollOffMinDistance = Tune.SoundMinDistance
				JackUpSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local JackDownSound = Instance.new("Sound",JRoot)
				JackDownSound.SoundId = "rbxassetid://" .. Tune.JackDownSoundId
				JackDownSound.Name = "JackDownSound"
				JackDownSound.Looped = false
				JackDownSound.Volume = Tune.SoundVolume
				JackDownSound.RollOffMinDistance = Tune.SoundMinDistance
				JackDownSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bJackUpSound = JackUpSound
				bJackDownSound = JackDownSound
			else
				local JackUpSound = Instance.new("Sound",JRoot)
				JackUpSound.SoundId = "rbxassetid://9066098958"
				JackUpSound.Name = "JackUpSound"
				JackUpSound.Looped = false
				JackUpSound.Volume = Tune.SoundVolume
				JackUpSound.PlaybackSpeed = 1
				JackUpSound.RollOffMinDistance = Tune.SoundMinDistance
				JackUpSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local JackDownSound = Instance.new("Sound",JRoot)
				JackDownSound.SoundId = "rbxassetid://9066098958"
				JackDownSound.Name = "JackDownSound"
				JackDownSound.Looped = false
				JackDownSound.Volume = Tune.SoundVolume
				JackUpSound.PlaybackSpeed = 1
				JackDownSound.RollOffMinDistance = Tune.SoundMinDistance
				JackDownSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bJackUpSound = JackUpSound
				bJackDownSound = JackDownSound
			end
		end

		local bRampOpenSound = nil;
		local bRampClosedSound = nil;
		local bRRoot = nil;
		if Tune.DoubleRampEnabled then
			local Ramp = Trailer.Misc:FindFirstChild("Ramp") or Trailer.Misc:FindFirstChild("Ramps") or Trailer.Body:FindFirstChild("Ramp") or Trailer.Body:FindFirstChild("Ramps") or Trailer.Body:FindFirstChild("TiltDeck") or Trailer.Misc:FindFirstChild("TiltDeck") or Trailer.Body:FindFirstChild("DumpBed") or Trailer.Misc:FindFirstChild("DumpBed")
			if Ramp.Name == "TiltDeck" then
				if Ramp:IsA("BasePart") then local RampModel = Instance.new("Model",Trailer.Misc) RampModel.Name = "TiltDeck" Ramp.Parent = RampModel Ramp = RampModel else Ramp.Parent = Trailer.Misc Ramp.Name = "TiltDeck" end
			elseif Ramp.Name == "Ramps" then
				if Ramp:IsA("BasePart") then local RampModel = Instance.new("Model",Trailer.Misc) RampModel.Name = "Ramps" Ramp.Parent = RampModel Ramp = RampModel else Ramp.Parent = Trailer.Misc Ramp.Name = "Ramps" end
			elseif Ramp.Name == "DumpBed" then
				if Ramp:IsA("BasePart") then local RampModel = Instance.new("Model",Trailer.Misc) RampModel.Name = "DumpBed" Ramp.Parent = RampModel Ramp = RampModel else Ramp.Parent = Trailer.Misc Ramp.Name = "DumpBed" end
			end
			local RRoot = Instance.new("Part")
			RRoot.Size = Vector3.new(1,1,1)
			RRoot.CanCollide = false
			RRoot.Transparency = 1
			RRoot.Name = "Root"
			bRRoot = RRoot
			local orientation, size = Ramp:GetBoundingBox()
			if Ramp.Name == "DumpBed" then
				RRoot.CFrame = orientation + Vector3.new(0,-size.Y/2+.15,size.Z/size.Z+2.55)
			else
				RRoot.CFrame = orientation + Vector3.new(0,-size.Y/2+.15,-size.Z/size.Z/2-.1)
			end
			RRoot.Parent = Ramp
			local RHold = RRoot:Clone()
			RHold.Name = "RHold"
			RHold.Parent = Trailer.Body
			local Weld = Instance.new("Weld")
			Weld.Name = "Pos"
			Weld.Parent = RRoot
			Weld.Part0 = RRoot
			Weld.Part1 = RHold
			ModelWeld(Ramp,RRoot)
			if Tune.RampSoundType == "Custom" then
				local RampUpSound = Instance.new("Sound",RRoot)
				RampUpSound.SoundId = "rbxassetid://" .. Tune.RampUpSoundId
				RampUpSound.Name = "RampUpSound"
				RampUpSound.Looped = false
				RampUpSound.Volume = Tune.SoundVolume
				RampUpSound.RollOffMinDistance = Tune.SoundMinDistance
				RampUpSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local RampDownSound = Instance.new("Sound",RRoot)
				RampDownSound.SoundId = "rbxassetid://" .. Tune.RampDownSoundId
				RampDownSound.Name = "RampDownSound"
				RampDownSound.Looped = false
				RampDownSound.Volume = Tune.SoundVolume
				RampDownSound.RollOffMinDistance = Tune.SoundMinDistance
				RampDownSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bRampOpenSound = RampUpSound
				bRampClosedSound = RampDownSound
			else
				local RampUpSound = Instance.new("Sound",RRoot)
				RampUpSound.SoundId = "rbxassetid://4416839551"
				RampUpSound.Name = "RampUpSound"
				RampUpSound.Looped = false
				RampUpSound.Volume = Tune.SoundVolume
				RampUpSound.PlaybackSpeed = Tune.DoubleRampTime+.2
				RampUpSound.RollOffMinDistance = Tune.SoundMinDistance
				RampUpSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local RampDownSound = Instance.new("Sound",RRoot)
				RampDownSound.SoundId = "rbxassetid://4416840411"
				RampDownSound.Name = "RampDownSound"
				RampDownSound.Looped = false
				RampDownSound.Volume = Tune.SoundVolume
				RampDownSound.PlaybackSpeed = Tune.DoubleRampTime+.2
				RampDownSound.RollOffMinDistance = Tune.SoundMinDistance
				RampDownSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bRampOpenSound = RampUpSound
				bRampClosedSound = RampDownSound
			end
		end

		local HGui = Rep:FindFirstChild("HitchGui")

		if Tune.InteractType == "Click" then
			--Hitch
			if Tune.DoubleHitchEnabled then
				local Hinteract = Instance.new("ClickDetector")
				Hinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Hinteract.Parent = bDoubleHitchPart
				Hinteract.MouseClick:Connect(function(player)
					if Tune.HitchType == "Click" then
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if bHitch.Attachment1 == nil then
								local HGuiClone = HGui:Clone()
								HGuiClone.Trailer.Value = Trailer
								HGuiClone.EventObject.Value = bHitchEvent
								wait()
								HGuiClone.Parent = player.PlayerGui
								HGuiClone.Controller.Disabled = false
							else
								bHitch.Attachment1 = nil
								bUnHitchedSound:Play()
								if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
									if Trailer.Body.Air_L:FindFirstChild("Spring") ~= nil and Trailer.Body.Air_R:FindFirstChild("Spring") ~= nil then
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring"):Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
									if Trailer.Body.Chain_L:FindFirstChild("Rope") ~= nil and Trailer.Body.Chain_R:FindFirstChild("Rope") ~= nil then
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope"):Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
									if Trailer.Body.ElectricCable:FindFirstChild("Spring") ~= nil then
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring"):Destroy()
									end
								end
								bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = true
								UpdateLights(Trailer)
							end
						end
					elseif Tune.HitchType == "Proximity" then
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if bHitch.Attachment1 == nil then
								for _,Part in pairs(game.Workspace:GetDescendants()) do
									if Part:IsA("BasePart") and Part.Name == "RearHitch" and Part.Parent ~= Trailer.Parent.Body and (Part.Position - bDoubleHitchPart.Position).Magnitude <= Tune.MaxHitchDistance then
										if Part:FindFirstChild("HitchA2") == nil then
											local A2 = Instance.new("Attachment", Part)
											A2.Name = "HitchA2"
											local H = bDoubleHitchPart:FindFirstChild("Coupler")
											H.Attachment1 = A2
											bDoubleHitchPart:FindFirstChild("HitchedSound"):Play()
											bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = false
											local TrChainL
											local TrChainR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Chain_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainL = prt
												end
												if prt.Name == "Chain_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainR = prt
												end
											end
											if Tune.SafetyChains then
												if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
													if TrChainL ~= nil and TrChainR ~= nil then
														local ChainL = Trailer.Body:FindFirstChild("Chain_L")
														local ChainR = Trailer.Body:FindFirstChild("Chain_R")
														local CL_A0 = Instance.new("Attachment",ChainL)
														local CL_A1 = Instance.new("Attachment",TrChainL)
														CL_A0.Name = "ChainA0"
														CL_A1.Name = "ChainA1"
														local CR_A0 = Instance.new("Attachment",ChainR)
														local CR_A1 = Instance.new("Attachment",TrChainR)
														CR_A0.Name = "ChainA0"
														CR_A1.Name = "ChainA1"
														local RopeL = Instance.new("RopeConstraint",ChainL)
														local RopeR = Instance.new("RopeConstraint",ChainR)
														RopeL.Name = "Rope"
														RopeL.Attachment0 = CL_A0
														RopeL.Attachment1 = CL_A1
														RopeL.Visible = true
														RopeL.Color = BrickColor.new(Tune.ChainColor)
														RopeL.Thickness = Tune.ChainThickness
														RopeR.Name = "Rope"
														RopeR.Attachment0 = CR_A0
														RopeR.Attachment1 = CR_A1
														RopeR.Visible = true
														RopeR.Color = BrickColor.new(Tune.ChainColor)
														RopeR.Thickness = Tune.ChainThickness
														RopeL.Length = Tune.ChainLength
														RopeR.Length = Tune.ChainLength
													end
												end
											end
											local TrCable
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "ElectricCable" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrCable = prt
												end
											end
											if Tune.ElectricCable then
												if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
													if TrCable ~= nil then
														local Cable = Trailer.Body:FindFirstChild("ElectricCable")
														local C_A0 = Instance.new("Attachment",Cable)
														local C_A1 = Instance.new("Attachment",TrCable)
														C_A0.Name = "CableA0"
														C_A1.Name = "CableA1"
														local Spring = Instance.new("SpringConstraint",Cable)
														Spring.Name = "Spring"
														Spring.Attachment0 = C_A0
														Spring.Attachment1 = C_A1
														Spring.Visible = true
														Spring.Color = BrickColor.new(Tune.CableColor)
														Spring.Thickness = Tune.CableThickness
														Spring.Radius = Tune.CableRadius
														Spring.Coils = 8
														Spring.Damping = 0
														Spring.Stiffness = 0
														Spring.FreeLength = 25
													end
												end
											end
											local TrAirL
											local TrAirR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Air_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirL = prt
												end
												if prt.Name == "Air_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirR = prt
												end
											end
											if Tune.AirHoses then
												if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
													if TrAirL ~= nil and TrAirR ~= nil then
														local AirL = Trailer.Body:FindFirstChild("Air_L")
														local AirR = Trailer.Body:FindFirstChild("Air_R")
														local AL_A0 = Instance.new("Attachment",AirL)
														local AL_A1 = Instance.new("Attachment",TrAirL)
														AL_A0.Name = "HoseA0"
														AL_A1.Name = "HoseA1"
														local AR_A0 = Instance.new("Attachment",AirR)
														local AR_A1 = Instance.new("Attachment",TrAirR)
														AR_A0.Name = "HoseA0"
														AR_A1.Name = "HoseA1"
														local SpringL = Instance.new("SpringConstraint",AirL)
														local SpringR = Instance.new("SpringConstraint",AirR)
														SpringL.Name = "Spring"
														SpringL.Attachment0 = AL_A0
														SpringL.Attachment1 = AL_A1
														SpringL.Visible = true
														SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
														SpringL.Thickness = Tune.HoseThickness
														SpringL.Radius = Tune.HoseRadius
														SpringL.Coils = 8
														SpringL.Damping = 0
														SpringL.Stiffness = 0
														SpringL.FreeLength = 25
														SpringR.Name = "Spring"
														SpringR.Attachment0 = AR_A0
														SpringR.Attachment1 = AR_A1
														SpringR.Visible = true
														SpringR.Color = BrickColor.new(Tune.HoseRightColor)
														SpringR.Thickness = Tune.HoseThickness
														SpringR.Radius = Tune.HoseRadius
														SpringR.Coils = 8
														SpringR.Damping = 0
														SpringR.Stiffness = 0
														SpringR.FreeLength = 25
													end
												end
											end
										else
											local H = bDoubleHitchPart:FindFirstChild("Coupler")
											H.Attachment1 = Part:FindFirstChild("HitchA2")
											bDoubleHitchPart:FindFirstChild("HitchedSound"):Play()
											bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = false
											local TrChainL
											local TrChainR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Chain_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainL = prt
												end
												if prt.Name == "Chain_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainR = prt
												end
											end
											if Tune.SafetyChains then
												if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
													if TrChainL ~= nil and TrChainR ~= nil then
														local ChainL = Trailer.Body:FindFirstChild("Chain_L")
														local ChainR = Trailer.Body:FindFirstChild("Chain_R")
														local CL_A0 = Instance.new("Attachment",ChainL)
														local CL_A1 = Instance.new("Attachment",TrChainL)
														CL_A0.Name = "ChainA0"
														CL_A1.Name = "ChainA1"
														local CR_A0 = Instance.new("Attachment",ChainR)
														local CR_A1 = Instance.new("Attachment",TrChainR)
														CR_A0.Name = "ChainA0"
														CR_A1.Name = "ChainA1"
														local RopeL = Instance.new("RopeConstraint",ChainL)
														local RopeR = Instance.new("RopeConstraint",ChainR)
														RopeL.Name = "Rope"
														RopeL.Attachment0 = CL_A0
														RopeL.Attachment1 = CL_A1
														RopeL.Visible = true
														RopeL.Color = BrickColor.new(Tune.ChainColor)
														RopeL.Thickness = Tune.ChainThickness
														RopeR.Name = "Rope"
														RopeR.Attachment0 = CR_A0
														RopeR.Attachment1 = CR_A1
														RopeR.Visible = true
														RopeR.Color = BrickColor.new(Tune.ChainColor)
														RopeR.Thickness = Tune.ChainThickness
														RopeL.Length = Tune.ChainLength
														RopeR.Length = Tune.ChainLength
													end
												end
											end
											local TrCable
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "ElectricCable" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrCable = prt
												end
											end
											if Tune.ElectricCable then
												if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
													if TrCable ~= nil then
														local Cable = Trailer.Body:FindFirstChild("ElectricCable")
														local C_A0 = Instance.new("Attachment",Cable)
														local C_A1 = Instance.new("Attachment",TrCable)
														C_A0.Name = "CableA0"
														C_A1.Name = "CableA1"
														local Spring = Instance.new("SpringConstraint",Cable)
														Spring.Name = "Spring"
														Spring.Attachment0 = C_A0
														Spring.Attachment1 = C_A1
														Spring.Visible = true
														Spring.Color = BrickColor.new(Tune.CableColor)
														Spring.Thickness = Tune.CableThickness
														Spring.Radius = Tune.CableRadius
														Spring.Coils = 8
														Spring.Damping = 0
														Spring.Stiffness = 0
														Spring.FreeLength = 25
													end
												end
											end
											local TrAirL
											local TrAirR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Air_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirL = prt
												end
												if prt.Name == "Air_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirR = prt
												end
											end
											if Tune.AirHoses then
												if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
													if TrAirL ~= nil and TrAirR ~= nil then
														local AirL = Trailer.Body:FindFirstChild("Air_L")
														local AirR = Trailer.Body:FindFirstChild("Air_R")
														local AL_A0 = Instance.new("Attachment",AirL)
														local AL_A1 = Instance.new("Attachment",TrAirL)
														AL_A0.Name = "HoseA0"
														AL_A1.Name = "HoseA1"
														local AR_A0 = Instance.new("Attachment",AirR)
														local AR_A1 = Instance.new("Attachment",TrAirR)
														AR_A0.Name = "HoseA0"
														AR_A1.Name = "HoseA1"
														local SpringL = Instance.new("SpringConstraint",AirL)
														local SpringR = Instance.new("SpringConstraint",AirR)
														SpringL.Name = "Spring"
														SpringL.Attachment0 = AL_A0
														SpringL.Attachment1 = AL_A1
														SpringL.Visible = true
														SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
														SpringL.Thickness = Tune.HoseThickness
														SpringL.Radius = Tune.HoseRadius
														SpringL.Coils = 8
														SpringL.Damping = 0
														SpringL.Stiffness = 0
														SpringL.FreeLength = 25
														SpringR.Name = "Spring"
														SpringR.Attachment0 = AR_A0
														SpringR.Attachment1 = AR_A1
														SpringR.Visible = true
														SpringR.Color = BrickColor.new(Tune.HoseRightColor)
														SpringR.Thickness = Tune.HoseThickness
														SpringR.Radius = Tune.HoseRadius
														SpringR.Coils = 8
														SpringR.Damping = 0
														SpringR.Stiffness = 0
														SpringR.FreeLength = 25
													end
												end
											end
										end
									end
								end
							else
								bHitch.Attachment1 = nil
								bUnHitchedSound:Play()
								if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
									if Trailer.Body.Air_L:FindFirstChild("Spring") ~= nil and Trailer.Body.Air_R:FindFirstChild("Spring") ~= nil then
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring"):Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
									if Trailer.Body.Chain_L:FindFirstChild("Rope") ~= nil and Trailer.Body.Chain_R:FindFirstChild("Rope") ~= nil then
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope"):Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
									if Trailer.Body.ElectricCable:FindFirstChild("Spring") ~= nil then
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring"):Destroy()
									end
								end
								bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = true
								UpdateLights(Trailer)
							end
						end
					end
				end)
			end
			--Jack
			if Tune.DoubleJackEnabled then
				local Jinteract = Instance.new("ClickDetector")
				Jinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Jinteract.Parent = Trailer.Body.JackHandle
				Jinteract.MouseClick:Connect(function(player)
					local FoundInTable = false
					if Tune.LockType == "Unlocked" then
						FoundInTable = true
					elseif Tune.LockType == "UserId" then
						if table.find(Tune.UserId,player.UserId) then
							FoundInTable = true
						end
					elseif Tune.LockType == "Whitelisted" then
						for _, Click in pairs(UserIds) do
							if player.UserId == Click and FoundInTable == false then
								FoundInTable = true
							end
						end
					end
					
					if FoundInTable == true then
						if bJackUp == false then
							local PosTween = TweenService:Create(bJRoot.Pos, TweenInfo.new(Tune.DoubleJackTime), {C0 = bJRoot.Pos.C0 * CFrame.new(Vector3.new(0,-Tune.JackDistance,0))})
							PosTween:Play()
							bJackUpSound:Play()
							bJackUp = true
							Trailer.Body.JackHandle.ProximityPrompt.ObjectText = "Lower Trailer Jack"
						elseif bJackUp == true then
							local PosTween = TweenService:Create(bJRoot.Pos, TweenInfo.new(Tune.DoubleJackTime), {C0 = bJRoot.Pos.C0 * CFrame.new(Vector3.new(0,Tune.JackDistance,0))})
							PosTween:Play()
							bJackDownSound:Play()
							bJackUp = false
							Trailer.Body.JackHandle.ProximityPrompt.ObjectText = "Raise Trailer Jack"
						end
					end
				end)
			end
			--Ramp
			if Tune.DoubleRampEnabled then
				local angle = math.deg(Tune.RampAngle)
				local Rinteract = Instance.new("ClickDetector")
				Rinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Rinteract.Parent = Trailer.Body.RampHandle
				Rinteract.MouseClick:Connect(function(player)
					local FoundInTable = false
					if Tune.LockType == "Unlocked" then
						FoundInTable = true
					elseif Tune.LockType == "UserId" then
						if table.find(Tune.UserId,player.UserId) then
							FoundInTable = true
						end
					elseif Tune.LockType == "Whitelisted" then
						for _, Click in pairs(UserIds) do
							if player.UserId == Click and FoundInTable == false then
								FoundInTable = true
							end
						end
					end
					
					if FoundInTable == true then
						if bRampDw == false then
							local AngleTween = TweenService:Create(bRRoot.Pos, TweenInfo.new(Tune.DoubleRampTime), {C0 = bRRoot.Pos.C0 * CFrame.Angles(math.rad(angle),0,0)})
							AngleTween:Play()
							bRampOpenSound:Play()
							bRampDw = true
							if Trailer.Misc:FindFirstChild("Ramps") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower Ramps"
							elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower TiltDeck"
							elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise DumpBed"
							end
						elseif bRampDw == true then
							local AngleTween = TweenService:Create(bRRoot.Pos, TweenInfo.new(Tune.DoubleRampTime), {C0 = bRRoot.Pos.C0 * CFrame.Angles(math.rad(-angle),0,0)})
							AngleTween:Play()
							bRampClosedSound:Play()
							bRampDw = false
							if Trailer.Misc:FindFirstChild("Ramps") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise Ramps"
							elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise TiltDeck"
							elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower DumpBed"
							end
						end
					end
				end)
			end

		elseif Tune.InteractType == "Prompt" then
			--Hitch
			if Tune.DoubleHitchEnabled then
				local Hinteract = Instance.new("ProximityPrompt")
				Hinteract.KeyboardKeyCode = Tune.PromptKeyInput
				Hinteract.GamepadKeyCode = Tune.PromptContlrInput
				Hinteract.HoldDuration = Tune.HoldDuration
				Hinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Hinteract.RequiresLineOfSight = false
				Hinteract.Parent = bDoubleHitchPart
				Hinteract.Triggered:Connect(function(player)
					if Tune.HitchType == "Click" then
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if bHitch.Attachment1 == nil then
								local HGuiClone = HGui:Clone()
								HGuiClone.Trailer.Value = Trailer
								HGuiClone.EventObject.Value = bHitchEvent
								wait()
								HGuiClone.Parent = player.PlayerGui
								HGuiClone.Controller.Disabled = false
							else
								bHitch.Attachment1 = nil
								bUnHitchedSound:Play()
								if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
									if Trailer.Body.Air_L:FindFirstChild("Spring") ~= nil and Trailer.Body.Air_R:FindFirstChild("Spring") ~= nil then
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring"):Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
									if Trailer.Body.Chain_L:FindFirstChild("Rope") ~= nil and Trailer.Body.Chain_R:FindFirstChild("Rope") ~= nil then
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope"):Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
									if Trailer.Body.ElectricCable:FindFirstChild("Spring") ~= nil then
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring"):Destroy()
									end
								end
								bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = true
								UpdateLights(Trailer)
							end
						end
					elseif Tune.HitchType == "Proximity" then
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if bHitch.Attachment1 == nil then
								for _,Part in pairs(game.Workspace:GetDescendants()) do
									if Part:IsA("BasePart") and Part.Name == "RearHitch" and Part.Parent.Parent.Name == "Dolly" and Part.Parent ~= Trailer.Body and (Part.Position - bDoubleHitchPart.Position).Magnitude <= Tune.MaxHitchDistance then
										if Part:FindFirstChild("HitchA2") == nil then
											local A2 = Instance.new("Attachment", Part)
											A2.Name = "HitchA2"
											local H = bDoubleHitchPart:FindFirstChild("Coupler")
											H.Attachment1 = A2
											bDoubleHitchPart:FindFirstChild("HitchedSound"):Play()
											bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = false
											local TrChainL
											local TrChainR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Chain_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainL = prt
												end
												if prt.Name == "Chain_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainR = prt
												end
											end
											if Tune.SafetyChains then
												if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
													if TrChainL ~= nil and TrChainR ~= nil then
														local ChainL = Trailer.Body:FindFirstChild("Chain_L")
														local ChainR = Trailer.Body:FindFirstChild("Chain_R")
														local CL_A0 = Instance.new("Attachment",ChainL)
														local CL_A1 = Instance.new("Attachment",TrChainL)
														CL_A0.Name = "ChainA0"
														CL_A1.Name = "ChainA1"
														local CR_A0 = Instance.new("Attachment",ChainR)
														local CR_A1 = Instance.new("Attachment",TrChainR)
														CR_A0.Name = "ChainA0"
														CR_A1.Name = "ChainA1"
														local RopeL = Instance.new("RopeConstraint",ChainL)
														local RopeR = Instance.new("RopeConstraint",ChainR)
														RopeL.Name = "Rope"
														RopeL.Attachment0 = CL_A0
														RopeL.Attachment1 = CL_A1
														RopeL.Visible = true
														RopeL.Color = BrickColor.new(Tune.ChainColor)
														RopeL.Thickness = Tune.ChainThickness
														RopeR.Name = "Rope"
														RopeR.Attachment0 = CR_A0
														RopeR.Attachment1 = CR_A1
														RopeR.Visible = true
														RopeR.Color = BrickColor.new(Tune.ChainColor)
														RopeR.Thickness = Tune.ChainThickness
														RopeL.Length = Tune.ChainLength
														RopeR.Length = Tune.ChainLength
													end
												end
											end
											local TrCable
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "ElectricCable" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrCable = prt
												end
											end
											if Tune.ElectricCable then
												if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
													if TrCable ~= nil then
														local Cable = Trailer.Body:FindFirstChild("ElectricCable")
														local C_A0 = Instance.new("Attachment",Cable)
														local C_A1 = Instance.new("Attachment",TrCable)
														C_A0.Name = "CableA0"
														C_A1.Name = "CableA1"
														local Spring = Instance.new("SpringConstraint",Cable)
														Spring.Name = "Spring"
														Spring.Attachment0 = C_A0
														Spring.Attachment1 = C_A1
														Spring.Visible = true
														Spring.Color = BrickColor.new(Tune.CableColor)
														Spring.Thickness = Tune.CableThickness
														Spring.Radius = Tune.CableRadius
														Spring.Coils = 8
														Spring.Damping = 0
														Spring.Stiffness = 0
														Spring.FreeLength = 25
													end
												end
											end
											local TrAirL
											local TrAirR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Air_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirL = prt
												end
												if prt.Name == "Air_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirR = prt
												end
											end
											if Tune.AirHoses then
												if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
													if TrAirL ~= nil and TrAirR ~= nil then
														local AirL = Trailer.Body:FindFirstChild("Air_L")
														local AirR = Trailer.Body:FindFirstChild("Air_R")
														local AL_A0 = Instance.new("Attachment",AirL)
														local AL_A1 = Instance.new("Attachment",TrAirL)
														AL_A0.Name = "HoseA0"
														AL_A1.Name = "HoseA1"
														local AR_A0 = Instance.new("Attachment",AirR)
														local AR_A1 = Instance.new("Attachment",TrAirR)
														AR_A0.Name = "HoseA0"
														AR_A1.Name = "HoseA1"
														local SpringL = Instance.new("SpringConstraint",AirL)
														local SpringR = Instance.new("SpringConstraint",AirR)
														SpringL.Name = "Spring"
														SpringL.Attachment0 = AL_A0
														SpringL.Attachment1 = AL_A1
														SpringL.Visible = true
														SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
														SpringL.Thickness = Tune.HoseThickness
														SpringL.Radius = Tune.HoseRadius
														SpringL.Coils = 8
														SpringL.Damping = 0
														SpringL.Stiffness = 0
														SpringL.FreeLength = 25
														SpringR.Name = "Spring"
														SpringR.Attachment0 = AR_A0
														SpringR.Attachment1 = AR_A1
														SpringR.Visible = true
														SpringR.Color = BrickColor.new(Tune.HoseRightColor)
														SpringR.Thickness = Tune.HoseThickness
														SpringR.Radius = Tune.HoseRadius
														SpringR.Coils = 8
														SpringR.Damping = 0
														SpringR.Stiffness = 0
														SpringR.FreeLength = 25
													end
												end
											end
										else
											local H = bDoubleHitchPart:FindFirstChild("Coupler")
											H.Attachment1 = Part:FindFirstChild("HitchA2")
											bDoubleHitchPart:FindFirstChild("HitchedSound"):Play()
											bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = false
											local TrChainL
											local TrChainR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Chain_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainL = prt
												end
												if prt.Name == "Chain_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainR = prt
												end
											end
											if Tune.SafetyChains then
												if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
													if TrChainL ~= nil and TrChainR ~= nil then
														local ChainL = Trailer.Body:FindFirstChild("Chain_L")
														local ChainR = Trailer.Body:FindFirstChild("Chain_R")
														local CL_A0 = Instance.new("Attachment",ChainL)
														local CL_A1 = Instance.new("Attachment",TrChainL)
														CL_A0.Name = "ChainA0"
														CL_A1.Name = "ChainA1"
														local CR_A0 = Instance.new("Attachment",ChainR)
														local CR_A1 = Instance.new("Attachment",TrChainR)
														CR_A0.Name = "ChainA0"
														CR_A1.Name = "ChainA1"
														local RopeL = Instance.new("RopeConstraint",ChainL)
														local RopeR = Instance.new("RopeConstraint",ChainR)
														RopeL.Name = "Rope"
														RopeL.Attachment0 = CL_A0
														RopeL.Attachment1 = CL_A1
														RopeL.Visible = true
														RopeL.Color = BrickColor.new(Tune.ChainColor)
														RopeL.Thickness = Tune.ChainThickness
														RopeR.Name = "Rope"
														RopeR.Attachment0 = CR_A0
														RopeR.Attachment1 = CR_A1
														RopeR.Visible = true
														RopeR.Color = BrickColor.new(Tune.ChainColor)
														RopeR.Thickness = Tune.ChainThickness
														RopeL.Length = Tune.ChainLength
														RopeR.Length = Tune.ChainLength
													end
												end
											end
											local TrCable
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "ElectricCable" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrCable = prt
												end
											end
											if Tune.ElectricCable then
												if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
													if TrCable ~= nil then
														local Cable = Trailer.Body:FindFirstChild("ElectricCable")
														local C_A0 = Instance.new("Attachment",Cable)
														local C_A1 = Instance.new("Attachment",TrCable)
														C_A0.Name = "CableA0"
														C_A1.Name = "CableA1"
														local Spring = Instance.new("SpringConstraint",Cable)
														Spring.Name = "Spring"
														Spring.Attachment0 = C_A0
														Spring.Attachment1 = C_A1
														Spring.Visible = true
														Spring.Color = BrickColor.new(Tune.CableColor)
														Spring.Thickness = Tune.CableThickness
														Spring.Radius = Tune.CableRadius
														Spring.Coils = 8
														Spring.Damping = 0
														Spring.Stiffness = 0
														Spring.FreeLength = 25
													end
												end
											end
											local TrAirL
											local TrAirR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Air_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirL = prt
												end
												if prt.Name == "Air_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirR = prt
												end
											end
											if Tune.AirHoses then
												if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
													if TrAirL ~= nil and TrAirR ~= nil then
														local AirL = Trailer.Body:FindFirstChild("Air_L")
														local AirR = Trailer.Body:FindFirstChild("Air_R")
														local AL_A0 = Instance.new("Attachment",AirL)
														local AL_A1 = Instance.new("Attachment",TrAirL)
														AL_A0.Name = "HoseA0"
														AL_A1.Name = "HoseA1"
														local AR_A0 = Instance.new("Attachment",AirR)
														local AR_A1 = Instance.new("Attachment",TrAirR)
														AR_A0.Name = "HoseA0"
														AR_A1.Name = "HoseA1"
														local SpringL = Instance.new("SpringConstraint",AirL)
														local SpringR = Instance.new("SpringConstraint",AirR)
														SpringL.Name = "Spring"
														SpringL.Attachment0 = AL_A0
														SpringL.Attachment1 = AL_A1
														SpringL.Visible = true
														SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
														SpringL.Thickness = Tune.HoseThickness
														SpringL.Radius = Tune.HoseRadius
														SpringL.Coils = 8
														SpringL.Damping = 0
														SpringL.Stiffness = 0
														SpringL.FreeLength = 25
														SpringR.Name = "Spring"
														SpringR.Attachment0 = AR_A0
														SpringR.Attachment1 = AR_A1
														SpringR.Visible = true
														SpringR.Color = BrickColor.new(Tune.HoseRightColor)
														SpringR.Thickness = Tune.HoseThickness
														SpringR.Radius = Tune.HoseRadius
														SpringR.Coils = 8
														SpringR.Damping = 0
														SpringR.Stiffness = 0
														SpringR.FreeLength = 25
													end
												end
											end
										end
									end
								end
							else
								bHitch.Attachment1 = nil
								bUnHitchedSound:Play()
								if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
									if Trailer.Body.Air_L:FindFirstChild("Spring") ~= nil and Trailer.Body.Air_R:FindFirstChild("Spring") ~= nil then
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring"):Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
									if Trailer.Body.Chain_L:FindFirstChild("Rope") ~= nil and Trailer.Body.Chain_R:FindFirstChild("Rope") ~= nil then
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope"):Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
									if Trailer.Body.ElectricCable:FindFirstChild("Spring") ~= nil then
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring"):Destroy()
									end
								end
								bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = true
								UpdateLights(Trailer)
							end
						end
					end
				end)
			end
			--Jack
			if Tune.DoubleJackEnabled then
				local Jinteract = Instance.new("ProximityPrompt")
				Jinteract.KeyboardKeyCode = Tune.PromptKeyInput
				Jinteract.GamepadKeyCode = Tune.PromptContlrInput
				Jinteract.HoldDuration = Tune.HoldDuration
				Jinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Jinteract.RequiresLineOfSight = false
				Jinteract.ObjectText = "Raise Trailer Jack"
				Jinteract.Parent = Trailer.Body.JackHandle
				Jinteract.Triggered:Connect(function(player)
					local FoundInTable = false
					if Tune.LockType == "Unlocked" then
						FoundInTable = true
					elseif Tune.LockType == "UserId" then
						if table.find(Tune.UserId,player.UserId) then
							FoundInTable = true
						end
					elseif Tune.LockType == "Whitelisted" then
						for _, Click in pairs(UserIds) do
							if player.UserId == Click and FoundInTable == false then
								FoundInTable = true
							end
						end
					end
					
					if FoundInTable == true then
						if bJackUp == false then
							local PosTween = TweenService:Create(bJRoot.Pos, TweenInfo.new(Tune.DoubleJackTime), {C0 = bJRoot.Pos.C0 * CFrame.new(Vector3.new(0,-Tune.JackDistance,0))})
							PosTween:Play()
							bJackUpSound:Play()
							bJackUp = true
							Trailer.Body.JackHandle.ProximityPrompt.ObjectText = "Lower Trailer Jack"
						elseif bJackUp == true then
							local PosTween = TweenService:Create(bJRoot.Pos, TweenInfo.new(Tune.DoubleJackTime), {C0 = bJRoot.Pos.C0 * CFrame.new(Vector3.new(0,Tune.JackDistance,0))})
							PosTween:Play()
							bJackDownSound:Play()
							bJackUp = false
							Trailer.Body.JackHandle.ProximityPrompt.ObjectText = "Raise Trailer Jack"
						end
					end
				end)
			end
			--Ramp
			if Tune.DoubleRampEnabled then
				local angle = math.deg(Tune.RampAngle)
				local Rinteract = Instance.new("ProximityPrompt")
				Rinteract.KeyboardKeyCode = Tune.PromptKeyInput
				Rinteract.GamepadKeyCode = Tune.PromptContlrInput
				Rinteract.HoldDuration = Tune.HoldDuration
				Rinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Rinteract.RequiresLineOfSight = false
				Rinteract.Parent = Trailer.Body.RampHandle
				if Trailer.Misc:FindFirstChild("Ramps") ~= nil then
					Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower Ramps"
				elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil then
					Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower TiltDeck" 
				elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil then
					Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise DumpBed"
				end
				Rinteract.Triggered:Connect(function(player)
					local FoundInTable = false
					if Tune.LockType == "Unlocked" then
						FoundInTable = true
					elseif Tune.LockType == "UserId" then
						if table.find(Tune.UserId,player.UserId) then
							FoundInTable = true
						end
					elseif Tune.LockType == "Whitelisted" then
						for _, Click in pairs(UserIds) do
							if player.UserId == Click and FoundInTable == false then
								FoundInTable = true
							end
						end
					end
					
					if FoundInTable == true then
						if bRampDw == false then
							local AngleTween = TweenService:Create(bRRoot.Pos, TweenInfo.new(Tune.DoubleRampTime), {C0 = bRRoot.Pos.C0 * CFrame.Angles(math.rad(angle),0,0)})
							AngleTween:Play()
							bRampOpenSound:Play()
							bRampDw = true
							if Trailer.Misc:FindFirstChild("Ramps") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower Ramps"
							elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower TiltDeck"
							elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise DumpBed"
							end
						elseif bRampDw == true then
							local AngleTween = TweenService:Create(bRRoot.Pos, TweenInfo.new(Tune.DoubleRampTime), {C0 = bRRoot.Pos.C0 * CFrame.Angles(math.rad(-angle),0,0)})
							AngleTween:Play()
							bRampClosedSound:Play()
							bRampDw = false
							if Trailer.Misc:FindFirstChild("Ramps") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise Ramps"
							elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise TiltDeck"
							elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower DumpBed"
							end
						end
					end
				end)
			end
		end
	else
		local Tune = require(Trailer:FindFirstChild("TGNG Trailer Settings"))

		local bHitchedSound = nil;
		local bUnHitchedSound = nil;
		local HitchPart = nil;
		local bHitch = nil;
		local bHitchEvent = nil;

		local bJackUp = false;
		local bRampDw = false;
		local bDoorOpn = false;
		local bDoor2Opn = false;
		local bDoor3Opn = false;
		local bDoor4Opn = false;
		
		local Door1 = nil;
		local Door2 = nil;
		local Door3 = nil;
		local Door4 = nil;
		
		local Winch1 = nil;
		local WinchWeld1 = nil;
		local Winch2 = nil;
		local WinchWeld2 = nil;
		local Winch3 = nil;
		local WinchWeld3 = nil;
		local Winch4 = nil;
		local WinchWeld4 = nil;
		if Tune.HitchEnabled then
			for i,v in pairs(Trailer.Body:GetChildren()) do
				if v:IsA("BasePart") and v.Name == "Hitch" then
					HitchPart = v
				end
			end
			local Hitch = Instance.new("BallSocketConstraint")
			Hitch.Parent = HitchPart
			Hitch.Name = "Coupler"
			bHitch = Hitch
			local HA0 = Instance.new("Attachment")
			HA0.Parent = HitchPart
			Hitch.Attachment0 = HA0
			local HitchEvent = Rep:FindFirstChild("HitchEvent"):Clone()
			HitchEvent.Parent = Trailer.Body
			bHitchEvent = HitchEvent
			if Tune.HitchSoundType == "Custom" then
				local HitchedSound = Instance.new("Sound",HitchPart)
				HitchedSound.SoundId = "rbxassetid://" .. Tune.HitchedSoundId
				HitchedSound.Name = "HitchedSound"
				HitchedSound.Looped = false
				HitchedSound.Volume = Tune.SoundVolume
				HitchedSound.RollOffMinDistance = Tune.SoundMinDistance
				HitchedSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local UnHitchedSound = Instance.new("Sound",HitchPart)
				UnHitchedSound.SoundId = "rbxassetid://" .. Tune.UnHitchedSoundId
				UnHitchedSound.Name = "UnHitchedSound"
				UnHitchedSound.Looped = false
				UnHitchedSound.Volume = Tune.SoundVolume
				UnHitchedSound.RollOffMinDistance = Tune.SoundMinDistance
				UnHitchedSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bHitchedSound = HitchedSound
				bUnHitchedSound = UnHitchedSound
			else
				local HitchedSound = Instance.new("Sound",HitchPart)
				HitchedSound.SoundId = "rbxassetid://9066107052"
				HitchedSound.Name = "HitchedSound"
				HitchedSound.Looped = false
				HitchedSound.Volume = Tune.SoundVolume
				HitchedSound.RollOffMinDistance = Tune.SoundMinDistance
				HitchedSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local UnHitchedSound = Instance.new("Sound",HitchPart)
				UnHitchedSound.SoundId = "rbxassetid://8589487194"
				UnHitchedSound.Name = "UnHitchedSound"
				UnHitchedSound.Looped = false
				UnHitchedSound.Volume = Tune.SoundVolume
				UnHitchedSound.RollOffMinDistance = Tune.SoundMinDistance
				UnHitchedSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bHitchedSound = HitchedSound
				bUnHitchedSound = UnHitchedSound
			end
		end

		local bJackUpSound = nil;
		local bJackDownSound = nil;
		local bJRoot = nil;
		if Tune.JackEnabled then
			local Jack = Trailer.Body:FindFirstChild("Jack") or Trailer.Body:FindFirstChild("Jacks") or Trailer.Body:FindFirstChild("Leg") or Trailer.Body:FindFirstChild("Legs") or Trailer.Misc:FindFirstChild("Jack") or Trailer.Misc:FindFirstChild("Jacks") or Trailer.Misc:FindFirstChild("Leg") or Trailer.Misc:FindFirstChild("Legs")
			if Jack:IsA("BasePart") then local JackModel = Instance.new("Model",Trailer.Misc) JackModel.Name = "Jack" Jack.Parent = JackModel Jack = JackModel else Jack.Parent = Trailer.Misc Jack.Name = "Jack" end
			local JRoot = Instance.new("Part")
			JRoot.Size = Vector3.new(1,1,1)
			JRoot.CanCollide = false
			JRoot.Transparency = 1
			JRoot.Name = "Root"
			bJRoot = JRoot
			local orientation, size = Jack:GetBoundingBox()
			JRoot.CFrame = orientation
			JRoot.Parent = Trailer.Misc.Jack
			local JHold = JRoot:Clone()
			JHold.Name = "LHold"
			JHold.Parent = Trailer.Body
			local Weld = Instance.new("Weld")
			Weld.Name = "Pos"
			Weld.Parent = JRoot
			Weld.Part0 = JRoot
			Weld.Part1 = JHold
			ModelWeld(Trailer.Misc.Jack,JRoot)
			if Tune.JackSoundType == "Custom" then
				local JackUpSound = Instance.new("Sound",JRoot)
				JackUpSound.SoundId = "rbxassetid://" .. Tune.JackUpSoundId
				JackUpSound.Name = "JackUpSound"
				JackUpSound.Looped = false
				JackUpSound.Volume = Tune.SoundVolume
				JackUpSound.RollOffMinDistance = Tune.SoundMinDistance
				JackUpSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local JackDownSound = Instance.new("Sound",JRoot)
				JackDownSound.SoundId = "rbxassetid://" .. Tune.JackDownSoundId
				JackDownSound.Name = "JackDownSound"
				JackDownSound.Looped = false
				JackDownSound.Volume = Tune.SoundVolume
				JackDownSound.RollOffMinDistance = Tune.SoundMinDistance
				JackDownSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bJackUpSound = JackUpSound
				bJackDownSound = JackDownSound
			else
				local JackUpSound = Instance.new("Sound",JRoot)
				JackUpSound.SoundId = "rbxassetid://9066098958"
				JackUpSound.Name = "JackUpSound"
				JackUpSound.Looped = false
				JackUpSound.Volume = Tune.SoundVolume
				JackUpSound.PlaybackSpeed = 1
				JackUpSound.RollOffMinDistance = Tune.SoundMinDistance
				JackUpSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local JackDownSound = Instance.new("Sound",JRoot)
				JackDownSound.SoundId = "rbxassetid://9066098958"
				JackDownSound.Name = "JackDownSound"
				JackDownSound.Looped = false
				JackDownSound.Volume = Tune.SoundVolume
				JackUpSound.PlaybackSpeed = 1
				JackDownSound.RollOffMinDistance = Tune.SoundMinDistance
				JackDownSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bJackUpSound = JackUpSound
				bJackDownSound = JackDownSound
			end
		end
		
		local bDoorOpenSound = nil;
		local bDoorClosedSound = nil;
		if Tune.DoorsEnabled then
			for i,v in pairs(Trailer:GetDescendants()) do
				if v:IsA("Model") and v.Name == "Door" or v:IsA("Model") and v.Name == "Door1" then
					Door1 = v
					local DRoot = v.Hinge
					DRoot.CanCollide = false
					DRoot.Transparency = 1
					local DHold = DRoot:Clone()
					DHold.Name = "DHold1"
					DHold.Parent = v.Parent
					local Weld = Instance.new("Weld")
					Weld.Name = "Pos"
					Weld.Parent = DRoot
					Weld.Part0 = DRoot
					Weld.Part1 = DHold
					ModelWeld(v,DRoot)
					Door1.Parent = Trailer.Misc
				elseif v:IsA("Model") and v.Name == "Door2" then
					Door2 = v
					local DRoot = v:FindFirstChild("Hinge")
					DRoot.CanCollide = false
					local DHold = DRoot:Clone()
					DHold.Name = "DHold2"
					DHold.Parent = v.Parent
					local Weld = Instance.new("Weld")
					Weld.Name = "Pos"
					Weld.Parent = DRoot
					Weld.Part0 = DRoot
					Weld.Part1 = DHold
					ModelWeld(v,DRoot)
					Door2.Parent = Trailer.Misc
				elseif v:IsA("Model") and v.Name == "Door3" then
					Door3 = v
					local DRoot = v:FindFirstChild("Hinge")
					DRoot.CanCollide = false
					local DHold = DRoot:Clone()
					DHold.Name = "DHold3"
					DHold.Parent = v.Parent
					local Weld = Instance.new("Weld")
					Weld.Name = "Pos"
					Weld.Parent = DRoot
					Weld.Part0 = DRoot
					Weld.Part1 = DHold
					ModelWeld(v,DRoot)
					Door3.Parent = Trailer.Misc
				elseif v:IsA("Model") and v.Name == "Door4" then
					Door4 = v
					local DRoot = v:FindFirstChild("Hinge")
					DRoot.CanCollide = false
					local DHold = DRoot:Clone()
					DHold.Name = "DHold4"
					DHold.Parent = v.Parent
					local Weld = Instance.new("Weld")
					Weld.Name = "Pos"
					Weld.Parent = DRoot
					Weld.Part0 = DRoot
					Weld.Part1 = DHold
					ModelWeld(v,DRoot)
					Door4.Parent = Trailer.Misc
				end
				if v:IsA("Model") and v.Name == "Door" or v.Name == "Door1" or v.Name == "Door2" or v.Name == "Door3" or v.Name == "Door4" then
					if Tune.WinchSoundType == "Custom" then
						local DoorOpenSound = Instance.new("Sound",v:FindFirstChild("Handle"))
						DoorOpenSound.SoundId = "rbxassetid://" .. Tune.DoorOpenSoundId
						DoorOpenSound.Name = "DoorOpenSound"
						DoorOpenSound.Looped = false
						DoorOpenSound.Volume = Tune.SoundVolume
						DoorOpenSound.RollOffMinDistance = Tune.SoundMinDistance
						DoorOpenSound.RollOffMaxDistance = Tune.SoundMaxDistance
						bDoorOpenSound = DoorOpenSound
						local DoorClosedSound = Instance.new("Sound",v:FindFirstChild("Handle"))
						DoorClosedSound.SoundId = "rbxassetid://" .. Tune.WinchUnHookedSoundId
						DoorClosedSound.Name = "DoorClosedSound"
						DoorClosedSound.Looped = false
						DoorClosedSound.Volume = Tune.SoundVolume
						DoorClosedSound.RollOffMinDistance = Tune.SoundMinDistance
						DoorClosedSound.RollOffMaxDistance = Tune.SoundMaxDistance
						bDoorClosedSound = DoorClosedSound
					else
						local DoorOpenSound = Instance.new("Sound",v:FindFirstChild("Handle"))
						DoorOpenSound.SoundId = "rbxassetid://4416839551"
						DoorOpenSound.Name = "DoorOpenSound"
						DoorOpenSound.Looped = false
						DoorOpenSound.Volume = Tune.SoundVolume
						DoorOpenSound.RollOffMinDistance = Tune.SoundMinDistance
						DoorOpenSound.RollOffMaxDistance = Tune.SoundMaxDistance
						bDoorOpenSound = DoorOpenSound
						local DoorClosedSound = Instance.new("Sound",v:FindFirstChild("Handle"))
						DoorClosedSound.SoundId = "rbxassetid://4416840411"
						DoorClosedSound.Name = "DoorClosedSound"
						DoorClosedSound.Looped = false
						DoorClosedSound.Volume = Tune.SoundVolume
						DoorClosedSound.RollOffMinDistance = Tune.SoundMinDistance
						DoorClosedSound.RollOffMaxDistance = Tune.SoundMaxDistance
						bDoorClosedSound = DoorClosedSound
					end
				end
			end
		end

		local bRampOpenSound = nil;
		local bRampClosedSound = nil;
		local bRRoot = nil;
		if Tune.RampEnabled then
			local Ramp = Trailer.Misc:FindFirstChild("Ramp") or Trailer.Misc:FindFirstChild("Ramps") or Trailer.Body:FindFirstChild("Ramp") or Trailer.Body:FindFirstChild("Ramps") or Trailer.Body:FindFirstChild("TiltDeck") or Trailer.Misc:FindFirstChild("TiltDeck") or Trailer.Body:FindFirstChild("DumpBed") or Trailer.Misc:FindFirstChild("DumpBed")
			if Ramp.Name == "TiltDeck" then
				if Ramp:IsA("BasePart") then local RampModel = Instance.new("Model",Trailer.Misc) RampModel.Name = "TiltDeck" Ramp.Parent = RampModel Ramp = RampModel else Ramp.Parent = Trailer.Misc Ramp.Name = "TiltDeck" end
			elseif Ramp.Name == "Ramps" then
				if Ramp:IsA("BasePart") then local RampModel = Instance.new("Model",Trailer.Misc) RampModel.Name = "Ramps" Ramp.Parent = RampModel Ramp = RampModel else Ramp.Parent = Trailer.Misc Ramp.Name = "Ramps" end
			elseif Ramp.Name == "DumpBed" then
				if Ramp:IsA("BasePart") then local RampModel = Instance.new("Model",Trailer.Misc) RampModel.Name = "DumpBed" Ramp.Parent = RampModel Ramp = RampModel else Ramp.Parent = Trailer.Misc Ramp.Name = "DumpBed" end
			end
			local RRoot = Instance.new("Part")
			RRoot.Size = Vector3.new(1,1,1)
			RRoot.CanCollide = false
			RRoot.Transparency = 1
			RRoot.Name = "Root"
			bRRoot = RRoot
			local orientation, size = Ramp:GetBoundingBox()
			if Ramp.Name == "DumpBed" then
				RRoot.CFrame = orientation + Vector3.new(0,-size.Y/2+.15,size.Z/size.Z+2.55)
			else
				RRoot.CFrame = orientation + Vector3.new(0,-size.Y/2+.15,-size.Z/size.Z/2-.1)
			end
			RRoot.Orientation = Vector3.new(0,180,0)
			RRoot.Parent = Ramp
			local RHold = RRoot:Clone()
			RHold.Name = "RHold"
			RHold.Parent = Trailer.Body
			local Weld = Instance.new("Weld")
			Weld.Name = "Pos"
			Weld.Parent = RRoot
			Weld.Part0 = RRoot
			Weld.Part1 = RHold
			ModelWeld(Ramp,RRoot)
			if Tune.RampSoundType == "Custom" then
				local RampUpSound = Instance.new("Sound",RRoot)
				RampUpSound.SoundId = "rbxassetid://" .. Tune.RampUpSoundId
				RampUpSound.Name = "RampUpSound"
				RampUpSound.Looped = false
				RampUpSound.Volume = Tune.SoundVolume
				RampUpSound.RollOffMinDistance = Tune.SoundMinDistance
				RampUpSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local RampDownSound = Instance.new("Sound",RRoot)
				RampDownSound.SoundId = "rbxassetid://" .. Tune.RampDownSoundId
				RampDownSound.Name = "RampDownSound"
				RampDownSound.Looped = false
				RampDownSound.Volume = Tune.SoundVolume
				RampDownSound.RollOffMinDistance = Tune.SoundMinDistance
				RampDownSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bRampOpenSound = RampUpSound
				bRampClosedSound = RampDownSound
			else
				local RampUpSound = Instance.new("Sound",RRoot)
				RampUpSound.SoundId = "rbxassetid://4416839551"
				RampUpSound.Name = "RampUpSound"
				RampUpSound.Looped = false
				RampUpSound.Volume = Tune.SoundVolume
				RampUpSound.PlaybackSpeed = Tune.RampTime+.2
				RampUpSound.RollOffMinDistance = Tune.SoundMinDistance
				RampUpSound.RollOffMaxDistance = Tune.SoundMaxDistance
				local RampDownSound = Instance.new("Sound",RRoot)
				RampDownSound.SoundId = "rbxassetid://4416840411"
				RampDownSound.Name = "RampDownSound"
				RampDownSound.Looped = false
				RampDownSound.Volume = Tune.SoundVolume
				RampDownSound.PlaybackSpeed = Tune.RampTime+.2
				RampDownSound.RollOffMinDistance = Tune.SoundMinDistance
				RampDownSound.RollOffMaxDistance = Tune.SoundMaxDistance
				bRampOpenSound = RampUpSound
				bRampClosedSound = RampDownSound
			end
		end
		

		local bWinchHookedSound = nil;
		local bWinchUnHookedSound = nil;
		local bWinchActiveSound = nil;
		if Tune.WinchesEnabled then
			for i,v in pairs(Trailer:GetDescendants()) do
				if v:IsA("Model") and v.Name == "Winch" or v:IsA("Model") and v.Name == "Winch1" then
					Winch1 = v
					WinchWeld1 = v:FindFirstChild("WeldPart")
				elseif v:IsA("Model") and v.Name == "Winch2" then
					Winch2 = v
					WinchWeld2 = v:FindFirstChild("WeldPart")
				elseif v:IsA("Model") and v.Name == "Winch3" then
					Winch3 = v
					WinchWeld3 = v:FindFirstChild("WeldPart")
				elseif v:IsA("Model") and v.Name == "Winch4" then
					Winch4 = v
					WinchWeld4 = v:FindFirstChild("WeldPart")
				end
				if v:IsA("Model") and v.Name == "Winch" or v.Name == "Winch1" or v.Name == "Winch2" or v.Name == "Winch3" or v.Name == "Winch4" then
					if Tune.WinchSoundType == "Custom" then
						local WinchHookedSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchHookedSound.SoundId = "rbxassetid://" .. Tune.WinchHookedSoundId
						WinchHookedSound.Name = "WinchHookedSound"
						WinchHookedSound.Looped = false
						WinchHookedSound.Volume = Tune.SoundVolume
						WinchHookedSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchHookedSound.RollOffMaxDistance = Tune.SoundMaxDistance
						local WinchUnHookedSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchUnHookedSound.SoundId = "rbxassetid://" .. Tune.WinchUnHookedSoundId
						WinchUnHookedSound.Name = "WinchUnHookedSound"
						WinchUnHookedSound.Looped = false
						WinchUnHookedSound.Volume = Tune.SoundVolume
						WinchUnHookedSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchUnHookedSound.RollOffMaxDistance = Tune.SoundMaxDistance
						local WinchActiveSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchActiveSound.SoundId = "rbxassetid://" .. Tune.WinchActiveSoundId
						WinchActiveSound.Name = "WinchActiveSound"
						WinchActiveSound.Looped = true
						WinchActiveSound.Volume = Tune.SoundVolume
						WinchActiveSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchActiveSound.RollOffMaxDistance = Tune.SoundMaxDistance
						local WinchWeldSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchWeldSound.SoundId = "rbxassetid://" .. Tune.WinchWeldSoundId
						WinchWeldSound.Name = "WinchWeldSound"
						WinchWeldSound.Looped = false
						WinchWeldSound.Volume = Tune.SoundVolume
						WinchWeldSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchWeldSound.RollOffMaxDistance = Tune.SoundMaxDistance
						local WinchReleaseSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchReleaseSound.SoundId = "rbxassetid://" .. Tune.WinchReleaseSoundId
						WinchReleaseSound.Name = "WinchReleaseSound"
						WinchReleaseSound.Looped = false
						WinchReleaseSound.Volume = Tune.SoundVolume
						WinchReleaseSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchReleaseSound.RollOffMaxDistance = Tune.SoundMaxDistance
					else
						local WinchHookedSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchHookedSound.SoundId = "rbxassetid://9066120153"
						WinchHookedSound.Name = "WinchHookedSound"
						WinchHookedSound.Looped = false
						WinchHookedSound.Volume = Tune.SoundVolume
						WinchHookedSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchHookedSound.RollOffMaxDistance = Tune.SoundMaxDistance
						local WinchUnHookedSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchUnHookedSound.SoundId = "rbxassetid://9066122433"
						WinchUnHookedSound.Name = "WinchUnHookedSound"
						WinchUnHookedSound.Looped = false
						WinchUnHookedSound.Volume = Tune.SoundVolume
						WinchUnHookedSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchUnHookedSound.RollOffMaxDistance = Tune.SoundMaxDistance
						local WinchActiveSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchActiveSound.SoundId = "rbxassetid://9066124020"
						WinchActiveSound.Name = "WinchActiveSound"
						WinchActiveSound.Looped = true
						WinchActiveSound.Volume = Tune.SoundVolume
						WinchActiveSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchActiveSound.RollOffMaxDistance = Tune.SoundMaxDistance
						bWinchHookedSound = WinchHookedSound
						bWinchUnHookedSound = WinchUnHookedSound
						bWinchActiveSound = WinchActiveSound
						local WinchWeldSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchWeldSound.SoundId = "rbxassetid://9066125709"
						WinchWeldSound.Name = "WinchWeldSound"
						WinchWeldSound.Looped = false
						WinchWeldSound.Volume = Tune.SoundVolume
						WinchWeldSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchWeldSound.RollOffMaxDistance = Tune.SoundMaxDistance
						local WinchReleaseSound = Instance.new("Sound",v:FindFirstChild("WinchPart"))
						WinchReleaseSound.SoundId = "rbxassetid://9066127405"
						WinchReleaseSound.Name = "WinchReleaseSound"
						WinchReleaseSound.Looped = false
						WinchReleaseSound.Volume = Tune.SoundVolume
						WinchReleaseSound.RollOffMinDistance = Tune.SoundMinDistance
						WinchReleaseSound.RollOffMaxDistance = Tune.SoundMaxDistance
					end
				end
			end
		end

		local HGui = Rep:FindFirstChild("HitchGui")
		local WGui = Rep:FindFirstChild("TS_WinchGui")
		local WinchEvent
		if Winch1 ~= nil then
			WinchEvent = Rep:FindFirstChild("WinchEvent"):Clone()
			WinchEvent.Parent = Trailer.Body
		end

		if Tune.InteractType == "Click" then
			--Hitch
			if Tune.HitchEnabled then
				local Hinteract = Instance.new("ClickDetector")
				Hinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Hinteract.Parent = HitchPart
				Hinteract.MouseClick:Connect(function(player)
					if Tune.HitchType == "Click" then
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if bHitch.Attachment1 == nil then
								local HGuiClone = HGui:Clone()
								HGuiClone.Trailer.Value = Trailer
								HGuiClone.EventObject.Value = bHitchEvent
								wait()
								HGuiClone.Parent = player.PlayerGui
								HGuiClone.Controller.Disabled = false
							else
								bHitch.Attachment1 = nil
								bUnHitchedSound:Play()
								if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
									if Trailer.Body.Air_L:FindFirstChild("Spring") ~= nil and Trailer.Body.Air_R:FindFirstChild("Spring") ~= nil then
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring"):Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
									if Trailer.Body.Chain_L:FindFirstChild("Rope") ~= nil and Trailer.Body.Chain_R:FindFirstChild("Rope") ~= nil then
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope"):Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
									if Trailer.Body.ElectricCable:FindFirstChild("Spring") ~= nil then
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring"):Destroy()
									end
								end
								bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = true
								UpdateLights(Trailer)
							end
						end
					elseif Tune.HitchType == "Proximity" then
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if bHitch.Attachment1 == nil then
								for _,Part in pairs(game.Workspace:GetDescendants()) do
									if Part:IsA("BasePart") and Part.Name == "Hitch" and Part.Parent ~= Trailer.Body and (Part.Position - HitchPart.Position).Magnitude <= Tune.MaxHitchDistance then
										if Part:FindFirstChild("HitchA2") == nil then
											local A2 = Instance.new("Attachment", Part)
											A2.Name = "HitchA2"
											local H = HitchPart:FindFirstChild("Coupler")
											H.Attachment1 = A2
											HitchPart:FindFirstChild("HitchedSound"):Play()
											bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = false
											local TrChainL
											local TrChainR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Chain_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainL = prt
												end
												if prt.Name == "Chain_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainR = prt
												end
											end
											if Tune.SafetyChains then
												if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
													if TrChainL ~= nil and TrChainR ~= nil then
														local ChainL = Trailer.Body:FindFirstChild("Chain_L")
														local ChainR = Trailer.Body:FindFirstChild("Chain_R")
														local CL_A0 = Instance.new("Attachment",ChainL)
														local CL_A1 = Instance.new("Attachment",TrChainL)
														CL_A0.Name = "ChainA0"
														CL_A1.Name = "ChainA1"
														local CR_A0 = Instance.new("Attachment",ChainR)
														local CR_A1 = Instance.new("Attachment",TrChainR)
														CR_A0.Name = "ChainA0"
														CR_A1.Name = "ChainA1"
														local RopeL = Instance.new("RopeConstraint",ChainL)
														local RopeR = Instance.new("RopeConstraint",ChainR)
														RopeL.Name = "Rope"
														RopeL.Attachment0 = CL_A0
														RopeL.Attachment1 = CL_A1
														RopeL.Visible = true
														RopeL.Color = BrickColor.new(Tune.ChainColor)
														RopeL.Thickness = Tune.ChainThickness
														RopeR.Name = "Rope"
														RopeR.Attachment0 = CR_A0
														RopeR.Attachment1 = CR_A1
														RopeR.Visible = true
														RopeR.Color = BrickColor.new(Tune.ChainColor)
														RopeR.Thickness = Tune.ChainThickness
														RopeL.Length = Tune.ChainLength
														RopeR.Length = Tune.ChainLength
													end
												end
											end
											local TrCable
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "ElectricCable" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrCable = prt
												end
											end
											if Tune.ElectricCable then
												if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
													if TrCable ~= nil then
														local Cable = Trailer.Body:FindFirstChild("ElectricCable")
														local C_A0 = Instance.new("Attachment",Cable)
														local C_A1 = Instance.new("Attachment",TrCable)
														C_A0.Name = "CableA0"
														C_A1.Name = "CableA1"
														local Spring = Instance.new("SpringConstraint",Cable)
														Spring.Name = "Spring"
														Spring.Attachment0 = C_A0
														Spring.Attachment1 = C_A1
														Spring.Visible = true
														Spring.Color = BrickColor.new(Tune.CableColor)
														Spring.Thickness = Tune.CableThickness
														Spring.Radius = Tune.CableRadius
														Spring.Coils = 8
														Spring.Damping = 0
														Spring.Stiffness = 0
														Spring.FreeLength = 25
													end
												end
											end
											local TrAirL
											local TrAirR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Air_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirL = prt
												end
												if prt.Name == "Air_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirR = prt
												end
											end
											if Tune.AirHoses then
												if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
													if TrAirL ~= nil and TrAirR ~= nil then
														local AirL = Trailer.Body:FindFirstChild("Air_L")
														local AirR = Trailer.Body:FindFirstChild("Air_R")
														local AL_A0 = Instance.new("Attachment",AirL)
														local AL_A1 = Instance.new("Attachment",TrAirL)
														AL_A0.Name = "HoseA0"
														AL_A1.Name = "HoseA1"
														local AR_A0 = Instance.new("Attachment",AirR)
														local AR_A1 = Instance.new("Attachment",TrAirR)
														AR_A0.Name = "HoseA0"
														AR_A1.Name = "HoseA1"
														local SpringL = Instance.new("SpringConstraint",AirL)
														local SpringR = Instance.new("SpringConstraint",AirR)
														SpringL.Name = "Spring"
														SpringL.Attachment0 = AL_A0
														SpringL.Attachment1 = AL_A1
														SpringL.Visible = true
														SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
														SpringL.Thickness = Tune.HoseThickness
														SpringL.Radius = Tune.HoseRadius
														SpringL.Coils = 8
														SpringL.Damping = 0
														SpringL.Stiffness = 0
														SpringL.FreeLength = 25
														SpringR.Name = "Spring"
														SpringR.Attachment0 = AR_A0
														SpringR.Attachment1 = AR_A1
														SpringR.Visible = true
														SpringR.Color = BrickColor.new(Tune.HoseRightColor)
														SpringR.Thickness = Tune.HoseThickness
														SpringR.Radius = Tune.HoseRadius
														SpringR.Coils = 8
														SpringR.Damping = 0
														SpringR.Stiffness = 0
														SpringR.FreeLength = 25
													end
												end
											end
										else
											local H = HitchPart:FindFirstChild("Coupler")
											H.Attachment1 = Part:FindFirstChild("HitchA2")
											HitchPart:FindFirstChild("HitchedSound"):Play()
											bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = false
											local TrChainL
											local TrChainR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Chain_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainL = prt
												end
												if prt.Name == "Chain_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainR = prt
												end
											end
											if Tune.SafetyChains then
												if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
													if TrChainL ~= nil and TrChainR ~= nil then
														local ChainL = Trailer.Body:FindFirstChild("Chain_L")
														local ChainR = Trailer.Body:FindFirstChild("Chain_R")
														local CL_A0 = Instance.new("Attachment",ChainL)
														local CL_A1 = Instance.new("Attachment",TrChainL)
														CL_A0.Name = "ChainA0"
														CL_A1.Name = "ChainA1"
														local CR_A0 = Instance.new("Attachment",ChainR)
														local CR_A1 = Instance.new("Attachment",TrChainR)
														CR_A0.Name = "ChainA0"
														CR_A1.Name = "ChainA1"
														local RopeL = Instance.new("RopeConstraint",ChainL)
														local RopeR = Instance.new("RopeConstraint",ChainR)
														RopeL.Name = "Rope"
														RopeL.Attachment0 = CL_A0
														RopeL.Attachment1 = CL_A1
														RopeL.Visible = true
														RopeL.Color = BrickColor.new(Tune.ChainColor)
														RopeL.Thickness = Tune.ChainThickness
														RopeR.Name = "Rope"
														RopeR.Attachment0 = CR_A0
														RopeR.Attachment1 = CR_A1
														RopeR.Visible = true
														RopeR.Color = BrickColor.new(Tune.ChainColor)
														RopeR.Thickness = Tune.ChainThickness
														RopeL.Length = Tune.ChainLength
														RopeR.Length = Tune.ChainLength
													end
												end
											end
											local TrCable
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "ElectricCable" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrCable = prt
												end
											end
											if Tune.ElectricCable then
												if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
													if TrCable ~= nil then
														local Cable = Trailer.Body:FindFirstChild("ElectricCable")
														local C_A0 = Instance.new("Attachment",Cable)
														local C_A1 = Instance.new("Attachment",TrCable)
														C_A0.Name = "CableA0"
														C_A1.Name = "CableA1"
														local Spring = Instance.new("SpringConstraint",Cable)
														Spring.Name = "Spring"
														Spring.Attachment0 = C_A0
														Spring.Attachment1 = C_A1
														Spring.Visible = true
														Spring.Color = BrickColor.new(Tune.CableColor)
														Spring.Thickness = Tune.CableThickness
														Spring.Radius = Tune.CableRadius
														Spring.Coils = 8
														Spring.Damping = 0
														Spring.Stiffness = 0
														Spring.FreeLength = 25
													end
												end
											end
											local TrAirL
											local TrAirR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Air_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirL = prt
												end
												if prt.Name == "Air_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirR = prt
												end
											end
											if Tune.AirHoses then
												if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
													if TrAirL ~= nil and TrAirR ~= nil then
														local AirL = Trailer.Body:FindFirstChild("Air_L")
														local AirR = Trailer.Body:FindFirstChild("Air_R")
														local AL_A0 = Instance.new("Attachment",AirL)
														local AL_A1 = Instance.new("Attachment",TrAirL)
														AL_A0.Name = "HoseA0"
														AL_A1.Name = "HoseA1"
														local AR_A0 = Instance.new("Attachment",AirR)
														local AR_A1 = Instance.new("Attachment",TrAirR)
														AR_A0.Name = "HoseA0"
														AR_A1.Name = "HoseA1"
														local SpringL = Instance.new("SpringConstraint",AirL)
														local SpringR = Instance.new("SpringConstraint",AirR)
														SpringL.Name = "Spring"
														SpringL.Attachment0 = AL_A0
														SpringL.Attachment1 = AL_A1
														SpringL.Visible = true
														SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
														SpringL.Thickness = Tune.HoseThickness
														SpringL.Radius = Tune.HoseRadius
														SpringL.Coils = 8
														SpringL.Damping = 0
														SpringL.Stiffness = 0
														SpringL.FreeLength = 25
														SpringR.Name = "Spring"
														SpringR.Attachment0 = AR_A0
														SpringR.Attachment1 = AR_A1
														SpringR.Visible = true
														SpringR.Color = BrickColor.new(Tune.HoseRightColor)
														SpringR.Thickness = Tune.HoseThickness
														SpringR.Radius = Tune.HoseRadius
														SpringR.Coils = 8
														SpringR.Damping = 0
														SpringR.Stiffness = 0
														SpringR.FreeLength = 25
													end
												end
											end
										end
									end
								end
							else
								bHitch.Attachment1 = nil
								bUnHitchedSound:Play()
								if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
									if Trailer.Body.Air_L:FindFirstChild("Spring") ~= nil and Trailer.Body.Air_R:FindFirstChild("Spring") ~= nil then
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring"):Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
									if Trailer.Body.Chain_L:FindFirstChild("Rope") ~= nil and Trailer.Body.Chain_R:FindFirstChild("Rope") ~= nil then
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope"):Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
									if Trailer.Body.ElectricCable:FindFirstChild("Spring") ~= nil then
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring"):Destroy()
									end
								end
								bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = true
								UpdateLights(Trailer)
							end
						end
					end
				end)
			end
			--Jack
			if Tune.JackEnabled then
				local Jinteract = Instance.new("ClickDetector")
				Jinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Jinteract.Parent = Trailer.Body.JackHandle
				Jinteract.MouseClick:Connect(function(player)
					local FoundInTable = false
					if Tune.LockType == "Unlocked" then
						FoundInTable = true
					elseif Tune.LockType == "UserId" then
						if table.find(Tune.UserId,player.UserId) then
							FoundInTable = true
						end
					elseif Tune.LockType == "Whitelisted" then
						for _, Click in pairs(UserIds) do
							if player.UserId == Click and FoundInTable == false then
								FoundInTable = true
							end
						end
					end
					
					if FoundInTable == true then
						if bJackUp == false then
							local PosTween = TweenService:Create(bJRoot.Pos, TweenInfo.new(Tune.JackTime), {C0 = bJRoot.Pos.C0 * CFrame.new(Vector3.new(0,-Tune.JackDistance,0))})
							PosTween:Play()
							bJackUpSound:Play()
							bJackUp = true
							if Trailer.Body.JackHandle:FindFirstChild("ProximityPrompt") ~= nil then
								Trailer.Body.JackHandle.ProximityPrompt.ObjectText = "Lower Trailer Jack"
							end
						elseif bJackUp == true then
							local PosTween = TweenService:Create(bJRoot.Pos, TweenInfo.new(Tune.JackTime), {C0 = bJRoot.Pos.C0 * CFrame.new(Vector3.new(0,Tune.JackDistance,0))})
							PosTween:Play()
							bJackDownSound:Play()
							bJackUp = false
							if Trailer.Body.JackHandle:FindFirstChild("ProximityPrompt") ~= nil then
								Trailer.Body.JackHandle.ProximityPrompt.ObjectText = "Raise Trailer Jack"
							end
						end
					end
				end)
			end
			--Ramp
			if Tune.RampEnabled then
				local angle = math.deg(Tune.RampAngle)
				local Rinteract = Instance.new("ClickDetector")
				Rinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Rinteract.Parent = Trailer.Body.RampHandle
				Rinteract.MouseClick:Connect(function(player)
					local FoundInTable = false
					if Tune.LockType == "Unlocked" then
						FoundInTable = true
					elseif Tune.LockType == "UserId" then
						if table.find(Tune.UserId,player.UserId) then
							FoundInTable = true
						end
					elseif Tune.LockType == "Whitelisted" then
						for _, Click in pairs(UserIds) do
							if player.UserId == Click and FoundInTable == false then
								FoundInTable = true
							end
						end
					end
					
					if FoundInTable == true then
						if bRampDw == false then
							local AngleTween = TweenService:Create(bRRoot.Pos, TweenInfo.new(Tune.RampTime), {C0 = bRRoot.Pos.C0 * CFrame.Angles(math.rad(angle),0,0)})
							AngleTween:Play()
							bRampOpenSound:Play()
							bRampDw = true
							if Trailer.Misc:FindFirstChild("Ramps") ~= nil and Trailer.Body.RampHandle:FindFirstChild("ProximityPrompt") then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise Ramps"
							elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil and Trailer.Body.RampHandle:FindFirstChild("ProximityPrompt") then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise TiltDeck"
							elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil and Trailer.Body.RampHandle:FindFirstChild("ProximityPrompt") then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower DumpBed"
							end
						elseif bRampDw == true then
							local AngleTween = TweenService:Create(bRRoot.Pos, TweenInfo.new(Tune.RampTime), {C0 = bRRoot.Pos.C0 * CFrame.Angles(math.rad(-angle),0,0)})
							AngleTween:Play()
							bRampClosedSound:Play()
							bRampDw = false
							if Trailer.Misc:FindFirstChild("Ramps") ~= nil and Trailer.Body.RampHandle:FindFirstChild("ProximityPrompt") then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower Ramps"
							elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil and Trailer.Body.RampHandle:FindFirstChild("ProximityPrompt") then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower TiltDeck"
							elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil and Trailer.Body.RampHandle:FindFirstChild("ProximityPrompt") then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise DumpBed"
							end
						end
					end
				end)
			end
			--Doors
			if Tune.DoorsEnabled then
				if Door1 ~= nil then
					local angle = math.deg(Tune.Door1Angle)
					local D1interact = Instance.new("ClickDetector")
					D1interact.MaxActivationDistance = Tune.MaxActivationDistance
					D1interact.Parent = Door1.Handle
					D1interact.MouseClick:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end

						if FoundInTable == true then
							if bDoorOpn == false then
								local AngleTween = TweenService:Create(Door1.Hinge.Pos, TweenInfo.new(Tune.Door1Time), {C0 = Door1.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(angle))})
								AngleTween:Play()
								bDoorOpn = true
								Door1.Handle.DoorOpenSound:Play()
							elseif bDoorOpn == true then
								local AngleTween = TweenService:Create(Door1.Hinge.Pos, TweenInfo.new(Tune.Door1Time), {C0 = Door1.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(-angle))})
								AngleTween:Play()
								bDoorOpn = false
								Door1.Handle.DoorClosedSound:Play()
							end
						end
					end)
				end
				if Door2 ~= nil then
					local angle = math.deg(Tune.Door2Angle)
					local D2interact = Instance.new("ClickDetector")
					D2interact.MaxActivationDistance = Tune.MaxActivationDistance
					D2interact.Parent = Door2.Handle
					D2interact.MouseClick:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end

						if FoundInTable == true then
							if bDoor2Opn == false then
								local AngleTween = TweenService:Create(Door2.Hinge.Pos, TweenInfo.new(Tune.Door2Time), {C0 = Door2.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(angle))})
								AngleTween:Play()
								bDoor2Opn = true
								Door2.Handle.DoorOpenSound:Play()
							elseif bDoor2Opn == true then
								local AngleTween = TweenService:Create(Door2.Hinge.Pos, TweenInfo.new(Tune.Door2Time), {C0 = Door2.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(-angle))})
								AngleTween:Play()
								bDoor2Opn = false
								Door2.Handle.DoorClosedSound:Play()
							end
						end
					end)
				end
				if Door3 ~= nil then
					local angle = math.deg(Tune.Door3Angle)
					local D3interact = Instance.new("ClickDetector")
					D3interact.MaxActivationDistance = Tune.MaxActivationDistance
					D3interact.Parent = Door3.Handle
					D3interact.MouseClick:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end

						if FoundInTable == true then
							if bDoor3Opn == false then
								local AngleTween = TweenService:Create(Door3.Hinge.Pos, TweenInfo.new(Tune.Door3Time), {C0 = Door3.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(angle))})
								AngleTween:Play()
								bDoor3Opn = true
								Door3.Handle.DoorOpenSound:Play()
							elseif bDoor3Opn == true then
								local AngleTween = TweenService:Create(Door3.Hinge.Pos, TweenInfo.new(Tune.Door3Time), {C0 = Door3.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(-angle))})
								AngleTween:Play()
								bDoor3Opn = false
								Door3.Handle.DoorClosedSound:Play()
							end
						end
					end)
				end
				if Door4 ~= nil then
					local angle = math.deg(Tune.Door4Angle)
					local D4interact = Instance.new("ClickDetector")
					D4interact.MaxActivationDistance = Tune.MaxActivationDistance
					D4interact.Parent = Door4.Handle
					D4interact.MouseClick:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end

						if FoundInTable == true then
							if bDoor4Opn == false then
								local AngleTween = TweenService:Create(Door4.Hinge.Pos, TweenInfo.new(Tune.Door4Time), {C0 = Door4.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(angle))})
								AngleTween:Play()
								bDoor4Opn = true
								Door4.Handle.DoorOpenSound:Play()
							elseif bDoor4Opn == true then
								local AngleTween = TweenService:Create(Door4.Hinge.Pos, TweenInfo.new(Tune.Door4Time), {C0 = Door4.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(-angle))})
								AngleTween:Play()
								bDoor4Opn = false
								Door4.Handle.DoorClosedSound:Play()
							end
						end
					end)
				end
			end
			--Winches
			if Tune.WinchesEnabled then
				if Winch1 ~= nil then
					local W1interact = Instance.new("ClickDetector")
					W1interact.MaxActivationDistance = Tune.MaxActivationDistance
					W1interact.Parent = Winch1:FindFirstChild("WinchHandle")
					W1interact.MouseClick:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if player.PlayerGui:FindFirstChild("TS_WinchGui") == nil then
								local WGuiClone = WGui:Clone()
								WGuiClone.Trailer.Value = Trailer
								WGuiClone.Winch.Value = Winch1
								WGuiClone.EventObject.Value = WinchEvent
								wait()
								WGuiClone.Parent = player.PlayerGui
								WGuiClone.Controller.Disabled = false
							else
								player.PlayerGui:FindFirstChild("TS_WinchGui").Trailer.Value = Trailer
								player.PlayerGui:FindFirstChild("TS_WinchGui").Winch.Value = Winch1
								player.PlayerGui:FindFirstChild("TS_WinchGui").EventObject.Value = WinchEvent
							end
						end
					end)
				end
				if Winch2 ~= nil then
					local W2interact = Instance.new("ClickDetector")
					W2interact.MaxActivationDistance = Tune.MaxActivationDistance
					W2interact.Parent = Winch2:FindFirstChild("WinchHandle")
					W2interact.MouseClick:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if player.PlayerGui:FindFirstChild("TS_WinchGui") == nil then
								local WGuiClone = WGui:Clone()
								WGuiClone.Trailer.Value = Trailer
								WGuiClone.Winch.Value = Winch2
								WGuiClone.EventObject.Value = WinchEvent
								wait()
								WGuiClone.Parent = player.PlayerGui
								WGuiClone.Controller.Disabled = false
							else
								player.PlayerGui:FindFirstChild("TS_WinchGui").Trailer.Value = Trailer
								player.PlayerGui:FindFirstChild("TS_WinchGui").Winch.Value = Winch2
								player.PlayerGui:FindFirstChild("TS_WinchGui").EventObject.Value = WinchEvent
							end
						end
					end)
				end
				if Winch3 ~= nil then
					local W3interact = Instance.new("ClickDetector")
					W3interact.MaxActivationDistance = Tune.MaxActivationDistance
					W3interact.Parent = Winch3:FindFirstChild("WinchHandle")
					W3interact.MouseClick:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if player.PlayerGui:FindFirstChild("TS_WinchGui") == nil then
								local WGuiClone = WGui:Clone()
								WGuiClone.Trailer.Value = Trailer
								WGuiClone.Winch.Value = Winch3
								WGuiClone.EventObject.Value = WinchEvent
								wait()
								WGuiClone.Parent = player.PlayerGui
								WGuiClone.Controller.Disabled = false
							else
								player.PlayerGui:FindFirstChild("TS_WinchGui").Trailer.Value = Trailer
								player.PlayerGui:FindFirstChild("TS_WinchGui").Winch.Value = Winch3
								player.PlayerGui:FindFirstChild("TS_WinchGui").EventObject.Value = WinchEvent
							end
						end
					end)
				end
				if Winch4 ~= nil then
					local W4interact = Instance.new("ClickDetector")
					W4interact.MaxActivationDistance = Tune.MaxActivationDistance
					W4interact.Parent = Winch4:FindFirstChild("WinchHandle")
					W4interact.MouseClick:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if player.PlayerGui:FindFirstChild("TS_WinchGui") == nil then
								local WGuiClone = WGui:Clone()
								WGuiClone.Trailer.Value = Trailer
								WGuiClone.Winch.Value = Winch4
								WGuiClone.EventObject.Value = WinchEvent
								wait()
								WGuiClone.Parent = player.PlayerGui
								WGuiClone.Controller.Disabled = false
							else
								player.PlayerGui:FindFirstChild("TS_WinchGui").Trailer.Value = Trailer
								player.PlayerGui:FindFirstChild("TS_WinchGui").Winch.Value = Winch4
								player.PlayerGui:FindFirstChild("TS_WinchGui").EventObject.Value = WinchEvent
							end
						end
					end)
				end
			end

		elseif Tune.InteractType == "Prompt" then
			--Hitch
			if Tune.HitchEnabled then
				local Hinteract = Instance.new("ProximityPrompt")
				Hinteract.KeyboardKeyCode = Tune.PromptKeyInput
				Hinteract.GamepadKeyCode = Tune.PromptContlrInput
				Hinteract.HoldDuration = Tune.HoldDuration
				Hinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Hinteract.RequiresLineOfSight = false
				Hinteract.Parent = HitchPart
				Hinteract.Triggered:Connect(function(player)
					if Tune.HitchType == "Click" then
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if bHitch.Attachment1 == nil then
								local HGuiClone = HGui:Clone()
								HGuiClone.Trailer.Value = Trailer
								HGuiClone.EventObject.Value = bHitchEvent
								wait()
								HGuiClone.Parent = player.PlayerGui
								HGuiClone.Controller.Disabled = false
							else
								bHitch.Attachment1 = nil
								bUnHitchedSound:Play()
								if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
									if Trailer.Body.Air_L:FindFirstChild("Spring") ~= nil and Trailer.Body.Air_R:FindFirstChild("Spring") ~= nil then
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring"):Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
									if Trailer.Body.Chain_L:FindFirstChild("Rope") ~= nil and Trailer.Body.Chain_R:FindFirstChild("Rope") ~= nil then
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope"):Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
									if Trailer.Body.ElectricCable:FindFirstChild("Spring") ~= nil then
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring"):Destroy()
									end
								end
								bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = true
								UpdateLights(Trailer)
							end
						end
					elseif Tune.HitchType == "Proximity" then
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if bHitch.Attachment1 == nil then
								for _,Part in pairs(game.Workspace:GetDescendants()) do
									if Part:IsA("BasePart") and Part.Name == "Hitch" and Part.Parent ~= Trailer.Body and (Part.Position - HitchPart.Position).Magnitude <= Tune.MaxHitchDistance then
										if Part:FindFirstChild("HitchA2") == nil then
											local A2 = Instance.new("Attachment", Part)
											A2.Name = "HitchA2"
											local H = HitchPart:FindFirstChild("Coupler")
											H.Attachment1 = A2
											HitchPart:FindFirstChild("HitchedSound"):Play()
											bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = false
											local TrChainL
											local TrChainR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Chain_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainL = prt
												end
												if prt.Name == "Chain_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainR = prt
												end
											end
											if Tune.SafetyChains then
												if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
													if TrChainL ~= nil and TrChainR ~= nil then
														local ChainL = Trailer.Body:FindFirstChild("Chain_L")
														local ChainR = Trailer.Body:FindFirstChild("Chain_R")
														local CL_A0 = Instance.new("Attachment",ChainL)
														local CL_A1 = Instance.new("Attachment",TrChainL)
														CL_A0.Name = "ChainA0"
														CL_A1.Name = "ChainA1"
														local CR_A0 = Instance.new("Attachment",ChainR)
														local CR_A1 = Instance.new("Attachment",TrChainR)
														CR_A0.Name = "ChainA0"
														CR_A1.Name = "ChainA1"
														local RopeL = Instance.new("RopeConstraint",ChainL)
														local RopeR = Instance.new("RopeConstraint",ChainR)
														RopeL.Name = "Rope"
														RopeL.Attachment0 = CL_A0
														RopeL.Attachment1 = CL_A1
														RopeL.Visible = true
														RopeL.Color = BrickColor.new(Tune.ChainColor)
														RopeL.Thickness = Tune.ChainThickness
														RopeR.Name = "Rope"
														RopeR.Attachment0 = CR_A0
														RopeR.Attachment1 = CR_A1
														RopeR.Visible = true
														RopeR.Color = BrickColor.new(Tune.ChainColor)
														RopeR.Thickness = Tune.ChainThickness
														RopeL.Length = Tune.ChainLength
														RopeR.Length = Tune.ChainLength
													end
												end
											end
											local TrCable
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "ElectricCable" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrCable = prt
												end
											end
											if Tune.ElectricCable then
												if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
													if TrCable ~= nil then
														local Cable = Trailer.Body:FindFirstChild("ElectricCable")
														local C_A0 = Instance.new("Attachment",Cable)
														local C_A1 = Instance.new("Attachment",TrCable)
														C_A0.Name = "CableA0"
														C_A1.Name = "CableA1"
														local Spring = Instance.new("SpringConstraint",Cable)
														Spring.Name = "Spring"
														Spring.Attachment0 = C_A0
														Spring.Attachment1 = C_A1
														Spring.Visible = true
														Spring.Color = BrickColor.new(Tune.CableColor)
														Spring.Thickness = Tune.CableThickness
														Spring.Radius = Tune.CableRadius
														Spring.Coils = 8
														Spring.Damping = 0
														Spring.Stiffness = 0
														Spring.FreeLength = 25
													end
												end
											end
											local TrAirL
											local TrAirR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Air_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirL = prt
												end
												if prt.Name == "Air_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirR = prt
												end
											end
											if Tune.AirHoses then
												if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
													if TrAirL ~= nil and TrAirR ~= nil then
														local AirL = Trailer.Body:FindFirstChild("Air_L")
														local AirR = Trailer.Body:FindFirstChild("Air_R")
														local AL_A0 = Instance.new("Attachment",AirL)
														local AL_A1 = Instance.new("Attachment",TrAirL)
														AL_A0.Name = "HoseA0"
														AL_A1.Name = "HoseA1"
														local AR_A0 = Instance.new("Attachment",AirR)
														local AR_A1 = Instance.new("Attachment",TrAirR)
														AR_A0.Name = "HoseA0"
														AR_A1.Name = "HoseA1"
														local SpringL = Instance.new("SpringConstraint",AirL)
														local SpringR = Instance.new("SpringConstraint",AirR)
														SpringL.Name = "Spring"
														SpringL.Attachment0 = AL_A0
														SpringL.Attachment1 = AL_A1
														SpringL.Visible = true
														SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
														SpringL.Thickness = Tune.HoseThickness
														SpringL.Radius = Tune.HoseRadius
														SpringL.Coils = 8
														SpringL.Damping = 0
														SpringL.Stiffness = 0
														SpringL.FreeLength = 25
														SpringR.Name = "Spring"
														SpringR.Attachment0 = AR_A0
														SpringR.Attachment1 = AR_A1
														SpringR.Visible = true
														SpringR.Color = BrickColor.new(Tune.HoseRightColor)
														SpringR.Thickness = Tune.HoseThickness
														SpringR.Radius = Tune.HoseRadius
														SpringR.Coils = 8
														SpringR.Damping = 0
														SpringR.Stiffness = 0
														SpringR.FreeLength = 25
													end
												end
											end
										else
											local H = HitchPart:FindFirstChild("Coupler")
											H.Attachment1 = Part:FindFirstChild("HitchA2")
											HitchPart:FindFirstChild("HitchedSound"):Play()
											bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = false
											local TrChainL
											local TrChainR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Chain_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainL = prt
												end
												if prt.Name == "Chain_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrChainR = prt
												end
											end
											if Tune.SafetyChains then
												if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
													if TrChainL ~= nil and TrChainR ~= nil then
														local ChainL = Trailer.Body:FindFirstChild("Chain_L")
														local ChainR = Trailer.Body:FindFirstChild("Chain_R")
														local CL_A0 = Instance.new("Attachment",ChainL)
														local CL_A1 = Instance.new("Attachment",TrChainL)
														CL_A0.Name = "ChainA0"
														CL_A1.Name = "ChainA1"
														local CR_A0 = Instance.new("Attachment",ChainR)
														local CR_A1 = Instance.new("Attachment",TrChainR)
														CR_A0.Name = "ChainA0"
														CR_A1.Name = "ChainA1"
														local RopeL = Instance.new("RopeConstraint",ChainL)
														local RopeR = Instance.new("RopeConstraint",ChainR)
														RopeL.Name = "Rope"
														RopeL.Attachment0 = CL_A0
														RopeL.Attachment1 = CL_A1
														RopeL.Visible = true
														RopeL.Color = BrickColor.new(Tune.ChainColor)
														RopeL.Thickness = Tune.ChainThickness
														RopeR.Name = "Rope"
														RopeR.Attachment0 = CR_A0
														RopeR.Attachment1 = CR_A1
														RopeR.Visible = true
														RopeR.Color = BrickColor.new(Tune.ChainColor)
														RopeR.Thickness = Tune.ChainThickness
														RopeL.Length = Tune.ChainLength
														RopeR.Length = Tune.ChainLength
													end
												end
											end
											local TrCable
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "ElectricCable" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrCable = prt
												end
											end
											if Tune.ElectricCable then
												if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
													if TrCable ~= nil then
														local Cable = Trailer.Body:FindFirstChild("ElectricCable")
														local C_A0 = Instance.new("Attachment",Cable)
														local C_A1 = Instance.new("Attachment",TrCable)
														C_A0.Name = "CableA0"
														C_A1.Name = "CableA1"
														local Spring = Instance.new("SpringConstraint",Cable)
														Spring.Name = "Spring"
														Spring.Attachment0 = C_A0
														Spring.Attachment1 = C_A1
														Spring.Visible = true
														Spring.Color = BrickColor.new(Tune.CableColor)
														Spring.Thickness = Tune.CableThickness
														Spring.Radius = Tune.CableRadius
														Spring.Coils = 8
														Spring.Damping = 0
														Spring.Stiffness = 0
														Spring.FreeLength = 25
													end
												end
											end
											local TrAirL
											local TrAirR
											for i,prt in pairs(Part.Parent:GetChildren()) do
												if prt.Name == "Air_L" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirL = prt
												end
												if prt.Name == "Air_R" and (Part.Position - prt.Position).Magnitude <= 6 then
													TrAirR = prt
												end
											end
											if Tune.AirHoses then
												if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
													if TrAirL ~= nil and TrAirR ~= nil then
														local AirL = Trailer.Body:FindFirstChild("Air_L")
														local AirR = Trailer.Body:FindFirstChild("Air_R")
														local AL_A0 = Instance.new("Attachment",AirL)
														local AL_A1 = Instance.new("Attachment",TrAirL)
														AL_A0.Name = "HoseA0"
														AL_A1.Name = "HoseA1"
														local AR_A0 = Instance.new("Attachment",AirR)
														local AR_A1 = Instance.new("Attachment",TrAirR)
														AR_A0.Name = "HoseA0"
														AR_A1.Name = "HoseA1"
														local SpringL = Instance.new("SpringConstraint",AirL)
														local SpringR = Instance.new("SpringConstraint",AirR)
														SpringL.Name = "Spring"
														SpringL.Attachment0 = AL_A0
														SpringL.Attachment1 = AL_A1
														SpringL.Visible = true
														SpringL.Color = BrickColor.new(Tune.HoseLeftColor)
														SpringL.Thickness = Tune.HoseThickness
														SpringL.Radius = Tune.HoseRadius
														SpringL.Coils = 8
														SpringL.Damping = 0
														SpringL.Stiffness = 0
														SpringL.FreeLength = 25
														SpringR.Name = "Spring"
														SpringR.Attachment0 = AR_A0
														SpringR.Attachment1 = AR_A1
														SpringR.Visible = true
														SpringR.Color = BrickColor.new(Tune.HoseRightColor)
														SpringR.Thickness = Tune.HoseThickness
														SpringR.Radius = Tune.HoseRadius
														SpringR.Coils = 8
														SpringR.Damping = 0
														SpringR.Stiffness = 0
														SpringR.FreeLength = 25
													end
												end
											end
										end
									end
								end
							else
								bHitch.Attachment1 = nil
								bUnHitchedSound:Play()
								if Trailer.Body:FindFirstChild("Air_L") ~= nil and Trailer.Body:FindFirstChild("Air_R") ~= nil then
									if Trailer.Body.Air_L:FindFirstChild("Spring") ~= nil and Trailer.Body.Air_R:FindFirstChild("Spring") ~= nil then
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_L:FindFirstChild("Spring"):Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.Air_R:FindFirstChild("Spring"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("Chain_L") ~= nil and Trailer.Body:FindFirstChild("Chain_R") ~= nil then
									if Trailer.Body.Chain_L:FindFirstChild("Rope") ~= nil and Trailer.Body.Chain_R:FindFirstChild("Rope") ~= nil then
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_L:FindFirstChild("Rope"):Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment1:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope").Attachment0:Destroy()
										Trailer.Body.Chain_R:FindFirstChild("Rope"):Destroy()
									end
								end
								if Trailer.Body:FindFirstChild("ElectricCable") ~= nil then
									if Trailer.Body.ElectricCable:FindFirstChild("Spring") ~= nil then
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment1:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring").Attachment0:Destroy()
										Trailer.Body.ElectricCable:FindFirstChild("Spring"):Destroy()
									end
								end
								bHitchEvent:FindFirstChild("Trailer_Lights").Disabled = true
								UpdateLights(Trailer)
							end
						end
					end
				end)
			end
			--Jack
			if Tune.JackEnabled then
				local Jinteract = Instance.new("ProximityPrompt")
				Jinteract.KeyboardKeyCode = Tune.PromptKeyInput
				Jinteract.GamepadKeyCode = Tune.PromptContlrInput
				Jinteract.HoldDuration = Tune.HoldDuration
				Jinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Jinteract.RequiresLineOfSight = false
				Jinteract.ObjectText = "Raise Trailer Jack"
				Jinteract.Parent = Trailer.Body.JackHandle
				Jinteract.Triggered:Connect(function(player)
					local FoundInTable = false
					if Tune.LockType == "Unlocked" then
						FoundInTable = true
					elseif Tune.LockType == "UserId" then
						if table.find(Tune.UserId,player.UserId) then
							FoundInTable = true
						end
					elseif Tune.LockType == "Whitelisted" then
						for _, Click in pairs(UserIds) do
							if player.UserId == Click and FoundInTable == false then
								FoundInTable = true
							end
						end
					end
					
					if FoundInTable == true then
						if bJackUp == false then
							local PosTween = TweenService:Create(bJRoot.Pos, TweenInfo.new(Tune.JackTime), {C0 = bJRoot.Pos.C0 * CFrame.new(Vector3.new(0,-Tune.JackDistance,0))})
							PosTween:Play()
							bJackUpSound:Play()
							bJackUp = true
							Trailer.Body.JackHandle.ProximityPrompt.ObjectText = "Lower Trailer Jack"
						elseif bJackUp == true then
							local PosTween = TweenService:Create(bJRoot.Pos, TweenInfo.new(Tune.JackTime), {C0 = bJRoot.Pos.C0 * CFrame.new(Vector3.new(0,Tune.JackDistance,0))})
							PosTween:Play()
							bJackDownSound:Play()
							bJackUp = false
							Trailer.Body.JackHandle.ProximityPrompt.ObjectText = " Raise Trailer Jack"
						end
					end
				end)
			end
			--Ramp
			if Tune.RampEnabled then
				local angle = math.deg(Tune.RampAngle)
				local Rinteract = Instance.new("ProximityPrompt")
				Rinteract.KeyboardKeyCode = Tune.PromptKeyInput
				Rinteract.GamepadKeyCode = Tune.PromptContlrInput
				Rinteract.HoldDuration = Tune.HoldDuration
				Rinteract.MaxActivationDistance = Tune.MaxActivationDistance
				Rinteract.RequiresLineOfSight = false
				Rinteract.Parent = Trailer.Body.RampHandle
				if Trailer.Misc:FindFirstChild("Ramps") ~= nil then
					Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower Ramps"
				elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil then
					Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower TiltDeck"
				elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil then
					Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise DumpBed"
				end
				Rinteract.Triggered:Connect(function(player)
					local FoundInTable = false
					if Tune.LockType == "Unlocked" then
						FoundInTable = true
					elseif Tune.LockType == "UserId" then
						if table.find(Tune.UserId,player.UserId) then
							FoundInTable = true
						end
					elseif Tune.LockType == "Whitelisted" then
						for _, Click in pairs(UserIds) do
							if player.UserId == Click and FoundInTable == false then
								FoundInTable = true
							end
						end
					end
					
					if FoundInTable == true then
						if bRampDw == false then
							local AngleTween = TweenService:Create(bRRoot.Pos, TweenInfo.new(Tune.RampTime), {C0 = bRRoot.Pos.C0 * CFrame.Angles(math.rad(angle),0,0)})
							AngleTween:Play()
							bRampOpenSound:Play()
							bRampDw = true
							if Trailer.Misc:FindFirstChild("Ramps") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise Ramps"
							elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise TiltDeck"
							elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower DumpBed"
							end
						elseif bRampDw == true then
							local AngleTween = TweenService:Create(bRRoot.Pos, TweenInfo.new(Tune.RampTime), {C0 = bRRoot.Pos.C0 * CFrame.Angles(math.rad(-angle),0,0)})
							AngleTween:Play()
							bRampClosedSound:Play()
							bRampDw = false
							if Trailer.Misc:FindFirstChild("Ramps") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower Ramps"
							elseif Trailer.Misc:FindFirstChild("TiltDeck") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Lower TiltDeck"
							elseif Trailer.Misc:FindFirstChild("DumpBed") ~= nil then
								Trailer.Body.RampHandle.ProximityPrompt.ObjectText = "Raise DumpBed"
							end
						end
					end
				end)
			end
			--Doors
			if Tune.DoorsEnabled then
				if Door1 ~= nil then
					local angle = math.deg(Tune.Door1Angle)
					local D1interact = Instance.new("ProximityPrompt")
					D1interact.ObjectText = "Door1"
					D1interact.KeyboardKeyCode = Tune.PromptKeyInput
					D1interact.GamepadKeyCode = Tune.PromptContlrInput
					D1interact.HoldDuration = Tune.HoldDuration
					D1interact.MaxActivationDistance = Tune.MaxActivationDistance
					D1interact.RequiresLineOfSight = false
					D1interact.Parent = Door1:FindFirstChild("Handle")
					D1interact.Triggered:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end

						if FoundInTable == true then
							if bDoorOpn == false then
								local AngleTween = TweenService:Create(Door1.Hinge.Pos, TweenInfo.new(Tune.Door1Time), {C0 = Door1.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(angle))})
								AngleTween:Play()
								bDoorOpn = true
								Door1.Handle.DoorOpenSound:Play()
							elseif bDoorOpn == true then
								local AngleTween = TweenService:Create(Door1.Hinge.Pos, TweenInfo.new(Tune.Door1Time), {C0 = Door1.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(-angle))})
								AngleTween:Play()
								bDoorOpn = false
								Door1.Handle.DoorClosedSound:Play()
							end
						end
					end)
				end
				if Door2 ~= nil then
					local angle = math.deg(Tune.Door2Angle)
					local D2interact = Instance.new("ProximityPrompt")
					D2interact.ObjectText = "Door2"
					D2interact.KeyboardKeyCode = Tune.PromptKeyInput
					D2interact.GamepadKeyCode = Tune.PromptContlrInput
					D2interact.HoldDuration = Tune.HoldDuration
					D2interact.MaxActivationDistance = Tune.MaxActivationDistance
					D2interact.RequiresLineOfSight = false
					D2interact.Parent = Door2:FindFirstChild("Handle")
					D2interact.Triggered:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end

						if FoundInTable == true then
							if bDoor2Opn == false then
								local AngleTween = TweenService:Create(Door2.Hinge.Pos, TweenInfo.new(Tune.Door2Time), {C0 = Door2.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(angle))})
								AngleTween:Play()
								bDoor2Opn = true
								Door2.Handle.DoorOpenSound:Play()
							elseif bDoor2Opn == true then
								local AngleTween = TweenService:Create(Door2.Hinge.Pos, TweenInfo.new(Tune.Door2Time), {C0 = Door2.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(-angle))})
								AngleTween:Play()
								bDoor2Opn = false
								Door2.Handle.DoorClosedSound:Play()
							end
						end
					end)
				end
				if Door3 ~= nil then
					local angle = math.deg(Tune.Door3Angle)
					local D3interact = Instance.new("ProximityPrompt")
					D3interact.ObjectText = "Door3"
					D3interact.KeyboardKeyCode = Tune.PromptKeyInput
					D3interact.GamepadKeyCode = Tune.PromptContlrInput
					D3interact.HoldDuration = Tune.HoldDuration
					D3interact.MaxActivationDistance = Tune.MaxActivationDistance
					D3interact.RequiresLineOfSight = false
					D3interact.Parent = Door3:FindFirstChild("Handle")
					D3interact.Triggered:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end

						if FoundInTable == true then
							if bDoor3Opn == false then
								local AngleTween = TweenService:Create(Door3.Hinge.Pos, TweenInfo.new(Tune.Door3Time), {C0 = Door3.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(angle))})
								AngleTween:Play()
								bDoor3Opn = true
								Door3.Handle.DoorOpenSound:Play()
							elseif bDoor3Opn == true then
								local AngleTween = TweenService:Create(Door3.Hinge.Pos, TweenInfo.new(Tune.Door3Time), {C0 = Door3.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(-angle))})
								AngleTween:Play()
								bDoor3Opn = false
								Door3.Handle.DoorClosedSound:Play()
							end
						end
					end)
				end
				if Door4 ~= nil then
					local angle = math.deg(Tune.Door4Angle)
					local D4interact = Instance.new("ProximityPrompt")
					D4interact.ObjectText = "Door4"
					D4interact.KeyboardKeyCode = Tune.PromptKeyInput
					D4interact.GamepadKeyCode = Tune.PromptContlrInput
					D4interact.HoldDuration = Tune.HoldDuration
					D4interact.MaxActivationDistance = Tune.MaxActivationDistance
					D4interact.RequiresLineOfSight = false
					D4interact.Parent = Door4:FindFirstChild("Handle")
					D4interact.Triggered:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end

						if FoundInTable == true then
							if bDoor4Opn == false then
								local AngleTween = TweenService:Create(Door4.Hinge.Pos, TweenInfo.new(Tune.Door4Time), {C0 = Door4.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(angle))})
								AngleTween:Play()
								bDoor4Opn = true
								Door4.Handle.DoorOpenSound:Play()
							elseif bDoor4Opn == true then
								local AngleTween = TweenService:Create(Door4.Hinge.Pos, TweenInfo.new(Tune.Door4Time), {C0 = Door4.Hinge.Pos.C0 * CFrame.Angles(0,0,math.rad(-angle))})
								AngleTween:Play()
								bDoor4Opn = false
								Door4.Handle.DoorClosedSound:Play()
							end
						end
					end)
				end
			end
			--Winches
			if Tune.WinchesEnabled then
				if Winch1 ~= nil then
					local W1interact = Instance.new("ProximityPrompt")
					W1interact.ObjectText = "Winch1"
					W1interact.KeyboardKeyCode = Tune.PromptKeyInput
					W1interact.GamepadKeyCode = Tune.PromptContlrInput
					W1interact.HoldDuration = Tune.HoldDuration
					W1interact.MaxActivationDistance = Tune.MaxActivationDistance
					W1interact.RequiresLineOfSight = false
					W1interact.Parent = Winch1:FindFirstChild("WinchHandle")
					W1interact.Triggered:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if player.PlayerGui:FindFirstChild("TS_WinchGui") == nil then
								wait()
								local WGuiClone = WGui:Clone()
								WGuiClone.Trailer.Value = Trailer
								WGuiClone.Winch.Value = Winch1
								WGuiClone.EventObject.Value = WinchEvent
								wait()
								WGuiClone.Parent = player.PlayerGui
								WGuiClone.Controller.Disabled = false
							else
								player.PlayerGui:FindFirstChild("TS_WinchGui").Trailer.Value = Trailer
								player.PlayerGui:FindFirstChild("TS_WinchGui").Winch.Value = Winch1
								player.PlayerGui:FindFirstChild("TS_WinchGui").EventObject.Value = WinchEvent
							end
						end
					end)
				end
				if Winch2 ~= nil then
					local W2interact = Instance.new("ProximityPrompt")
					W2interact.ObjectText = "Winch2"
					W2interact.KeyboardKeyCode = Tune.PromptKeyInput
					W2interact.GamepadKeyCode = Tune.PromptContlrInput
					W2interact.HoldDuration = Tune.HoldDuration
					W2interact.MaxActivationDistance = Tune.MaxActivationDistance
					W2interact.RequiresLineOfSight = false
					W2interact.Parent = Winch2:FindFirstChild("WinchHandle")
					W2interact.Triggered:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if player.PlayerGui:FindFirstChild("TS_WinchGui") == nil then
								local WGuiClone = WGui:Clone()
								WGuiClone.Trailer.Value = Trailer
								WGuiClone.Winch.Value = Winch2
								WGuiClone.EventObject.Value = WinchEvent
								wait()
								WGuiClone.Parent = player.PlayerGui
								WGuiClone.Controller.Disabled = false
							else
								player.PlayerGui:FindFirstChild("TS_WinchGui").Trailer.Value = Trailer
								player.PlayerGui:FindFirstChild("TS_WinchGui").Winch.Value = Winch2
								player.PlayerGui:FindFirstChild("TS_WinchGui").EventObject.Value = WinchEvent
							end
						end
					end)
				end
				if Winch3 ~= nil then
					local W3interact = Instance.new("ProximityPrompt")
					W3interact.ObjectText = "Winch3"
					W3interact.KeyboardKeyCode = Tune.PromptKeyInput
					W3interact.GamepadKeyCode = Tune.PromptContlrInput
					W3interact.HoldDuration = Tune.HoldDuration
					W3interact.MaxActivationDistance = Tune.MaxActivationDistance
					W3interact.RequiresLineOfSight = false
					W3interact.Parent = Winch3:FindFirstChild("WinchHandle")
					W3interact.Triggered:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if player.PlayerGui:FindFirstChild("TS_WinchGui") == nil then
								local WGuiClone = WGui:Clone()
								WGuiClone.Trailer.Value = Trailer
								WGuiClone.Winch.Value = Winch3
								WGuiClone.EventObject.Value = WinchEvent
								wait()
								WGuiClone.Parent = player.PlayerGui
								WGuiClone.Controller.Disabled = false
							else
								player.PlayerGui:FindFirstChild("TS_WinchGui").Trailer.Value = Trailer
								player.PlayerGui:FindFirstChild("TS_WinchGui").Winch.Value = Winch3
								player.PlayerGui:FindFirstChild("TS_WinchGui").EventObject.Value = WinchEvent
							end
						end
					end)
				end
				if Winch4 ~= nil then
					local W4interact = Instance.new("ProximityPrompt")
					W4interact.ObjectText = "Winch4"
					W4interact.KeyboardKeyCode = Tune.PromptKeyInput
					W4interact.GamepadKeyCode = Tune.PromptContlrInput
					W4interact.HoldDuration = Tune.HoldDuration
					W4interact.MaxActivationDistance = Tune.MaxActivationDistance
					W4interact.RequiresLineOfSight = false
					W4interact.Parent = Winch4:FindFirstChild("WinchHandle")
					W4interact.Triggered:Connect(function(player)
						local FoundInTable = false
						if Tune.LockType == "Unlocked" then
							FoundInTable = true
						elseif Tune.LockType == "UserId" then
							if table.find(Tune.UserId,player.UserId) then
								FoundInTable = true
							end
						elseif Tune.LockType == "Whitelisted" then
							for _, Click in pairs(UserIds) do
								if player.UserId == Click and FoundInTable == false then
									FoundInTable = true
								end
							end
						end
						
						if FoundInTable == true then
							if player.PlayerGui:FindFirstChild("TS_WinchGui") == nil then
								local WGuiClone = WGui:Clone()
								WGuiClone.Trailer.Value = Trailer
								WGuiClone.Winch.Value = Winch4
								WGuiClone.EventObject.Value = WinchEvent
								wait()
								WGuiClone.Parent = player.PlayerGui
								WGuiClone.Controller.Disabled = false
							else
								player.PlayerGui:FindFirstChild("TS_WinchGui").Trailer.Value = Trailer
								player.PlayerGui:FindFirstChild("TS_WinchGui").Winch.Value = Winch4
								player.PlayerGui:FindFirstChild("TS_WinchGui").EventObject.Value = WinchEvent
							end
						end
					end)
				end
			end
		end
	end
end


function UpdateSound(Trailer, bBrakesApplied,bBrakesSpeed)
	local TBrakeSound = Trailer.Body:FindFirstChild("Prim"):WaitForChild("BrakeSound")
	if bBrakesApplied == true then
		TBrakeSound:Play()
		TBrakeSound.PlaybackSpeed = TBrakeSound.Parent.Velocity.Magnitude/TBrakeSound.Parent.Velocity.Magnitude/.5
		TBrakeSound.Volume = TBrakeSound.Volume + TBrakeSound.Parent.Velocity.Magnitude/TBrakeSound.Parent.Velocity.Magnitude/1
	else
		TBrakeSound:Stop()
		TBrakeSound.PlaybackSpeed = 0
		TBrakeSound.Volume = 0
	end
end

function CheckPrimary(Trailer)
	local Tune = require(Trailer:FindFirstChild("TGNG Trailer Settings"))
	local Rep = script:WaitForChild("R")
	local bTruck = nil;
	local bBrakesApplied = false;
	local bBrakesSpeed = 0;
	
	if Trailer.Body:FindFirstChild("Prim") ~= nil then
		if Tune.AutoFlip then
			local Att = Instance.new("Attachment",Trailer.Body.Prim)
			Att.Orientation = Vector3.new(0,0,0)
			local FlipG = Instance.new("AngularVelocity",Trailer.Body.Prim)
			FlipG.Name = "Flip"
			FlipG.Attachment0 = Att
			FlipG.MaxTorque = 0
			FlipG.AngularVelocity = Vector3.new(0,0,0)
			if Trailer:FindFirstChild("Tandem") ~= nil then
				local AttT = Instance.new("Attachment",Trailer:FindFirstChild("Tandem").Body.Prim)
				AttT.Orientation = Vector3.new(0,0,0)
				local FlipGT = Instance.new("AngularVelocity",Trailer:FindFirstChild("Tandem").Body.Prim)
				FlipGT.Name = "Flip"
				FlipGT.Attachment0 = AttT
				FlipGT.MaxTorque = 0
				FlipGT.AngularVelocity = Vector3.new(0,0,0)
				local AttD = Instance.new("Attachment",Trailer:FindFirstChild("Tandem"):FindFirstChild("Dolly").Body.Prim)
				AttD.Orientation = Vector3.new(0,0,0)
				local FlipGD = Instance.new("AngularVelocity",Trailer:FindFirstChild("Tandem"):FindFirstChild("Dolly").Body.Prim)
				FlipGD.Name = "Flip"
				FlipGD.Attachment0 = AttD
				FlipGD.MaxTorque = 0
				FlipGD.AngularVelocity = Vector3.new(0,0,0)
			end
		end
		
		if Tune.BrakesEnabled then
			local Brakes = Instance.new("BodyGyro",Trailer.Body.Prim)
			Brakes.Name = "Brakes"
			Brakes.D = 0
			Brakes.MaxTorque = Vector3.new(0,0,0)
			Brakes.P = 0
			
			if Tune.BrakeSoundType == "Custom" then
				local BrakeSound = Instance.new("Sound",Trailer.Body.Prim)
				BrakeSound.SoundId = "rbxassetid://" .. Tune.BrakeSoundId
				BrakeSound.Name = "BrakeSound"
				BrakeSound.Looped = true
				BrakeSound.Volume = Tune.SoundVolume
				BrakeSound.RollOffMinDistance = Tune.SoundMinDistance
				BrakeSound.RollOffMaxDistance = Tune.SoundMaxDistance
			else
				local BrakeSound = Rep:FindFirstChild("Sound"):Clone()
				BrakeSound.Parent = Trailer.Body.Prim
				BrakeSound.SoundId = "rbxassetid://8589153949"
				BrakeSound.Name = "BrakeSound"
				BrakeSound.Looped = true
				BrakeSound.Volume = Tune.SoundVolume
				BrakeSound.RollOffMinDistance = Tune.SoundMinDistance
				BrakeSound.RollOffMaxDistance = Tune.SoundMaxDistance
			end
			if Trailer:FindFirstChild("Tandem") ~= nil then
				local Brakes = Instance.new("BodyGyro",Trailer:FindFirstChild("Tandem").Body.Prim)
				Brakes.Name = "Brakes"
				Brakes.D = 0
				Brakes.MaxTorque = Vector3.new(0,0,0)
				Brakes.P = 0
				
				if Tune.BrakeSoundType == "Custom" then
					local BrakeSound = Instance.new("Sound",Trailer:FindFirstChild("Tandem").Body.Prim)
					BrakeSound.SoundId = "rbxassetid://" .. Tune.BrakeSoundId
					BrakeSound.Name = "BrakeSound"
					BrakeSound.Looped = true
					BrakeSound.Volume = Tune.SoundVolume
					BrakeSound.RollOffMinDistance = Tune.SoundMinDistance
					BrakeSound.RollOffMaxDistance = Tune.SoundMaxDistance
				else
					local BrakeSound = Rep:FindFirstChild("Sound"):Clone()
					BrakeSound.Parent = Trailer:FindFirstChild("Tandem").Body.Prim
					BrakeSound.SoundId = "rbxassetid://8589153949"
					BrakeSound.Name = "BrakeSound"
					BrakeSound.Looped = true
					BrakeSound.Volume = Tune.SoundVolume
					BrakeSound.RollOffMinDistance = Tune.SoundMinDistance
					BrakeSound.RollOffMaxDistance = Tune.SoundMaxDistance
				end
			end
		end
		
		
		
		while wait() do
			if Trailer.Body:FindFirstChild("Prim") ~= nil then
				if Trailer.Body.Hitch:FindFirstChild("Coupler") and Trailer.Body.Hitch:FindFirstChild("Coupler").Attachment1 ~= nil then
					bTruck = Trailer.Body.Hitch:FindFirstChild("Coupler").Attachment1.Parent.Parent.Parent
				else
					bTruck = nil
				end
			end
			
			--Flip
			if Tune.AutoFlip then
				Flip(Trailer)
				if Trailer:FindFirstChild("Tandem") ~= nil then
					Flip(Trailer.Tandem)
					Flip(Trailer.Tandem.Dolly)
				end
			end
			
			if Tune.BrakesEnabled then
				if bTruck ~= nil then
					local TBrakes = Trailer.Body:FindFirstChild("Prim"):WaitForChild("Brakes")
					local TBrakeSound = Trailer.Body:FindFirstChild("Prim"):WaitForChild("BrakeSound")
					if bTruck:FindFirstChild("DriveSeat").Throttle == -1 then
						if bTruck:FindFirstChild("DriveSeat").Velocity.Magnitude > 25 then
							TBrakes.D = 100
							TBrakes.MaxTorque = Vector3.new(0,Tune.BrakeForce,0)
							TBrakes.P = 100
							if bBrakesApplied == false then
								bBrakesApplied = true
								bBrakesSpeed = TBrakeSound.Parent.Velocity.Magnitude/2
								UpdateSound(Trailer,bBrakesApplied,bBrakesSpeed)
							end
							if Trailer:FindFirstChild("Tandem") ~= nil then
								local DBrakes = Trailer:FindFirstChild("Tandem").Body:FindFirstChild("Prim"):WaitForChild("Brakes")
								DBrakes.D = 100
								DBrakes.MaxTorque = Vector3.new(0,Tune.BrakeForce,0)
								DBrakes.P = 100
								UpdateSound(Trailer:FindFirstChild("Tandem"),bBrakesApplied,bBrakesSpeed)	
							end
						else
							TBrakes.D = 0
							TBrakes.MaxTorque = Vector3.new(0,0,0)
							TBrakes.P = 0
							bBrakesApplied = false
							bBrakesSpeed = 0
							UpdateSound(Trailer,bBrakesApplied,bBrakesSpeed)
							if Trailer:FindFirstChild("Tandem") ~= nil then
								local DBrakes = Trailer:FindFirstChild("Tandem").Body:FindFirstChild("Prim"):WaitForChild("Brakes")
								DBrakes.D = 0
								DBrakes.MaxTorque = Vector3.new(0,0,0)
								DBrakes.P = 0
								UpdateSound(Trailer:FindFirstChild("Tandem"),bBrakesApplied,bBrakesSpeed)	
							end
						end
					elseif bTruck:FindFirstChild("DriveSeat").Throttle ~= -1 then
						TBrakes.D = 0
						TBrakes.MaxTorque = Vector3.new(0,0,0)
						TBrakes.P = 0
						bBrakesApplied = false
						bBrakesSpeed = 0
						UpdateSound(Trailer,bBrakesApplied,bBrakesSpeed)
						if Trailer:FindFirstChild("Tandem") ~= nil then
							local DBrakes = Trailer:FindFirstChild("Tandem").Body:FindFirstChild("Prim"):WaitForChild("Brakes")
							DBrakes.D = 0
							DBrakes.MaxTorque = Vector3.new(0,0,0)
							DBrakes.P = 0
							UpdateSound(Trailer:FindFirstChild("Tandem"),bBrakesApplied,bBrakesSpeed)	
						end
					end
				end
			end
			
			--Propmts
			if Tune.InteractType == "Prompt" then
				--Hitch
				if Tune.HitchEnabled then
					if Trailer.Body.Hitch.Coupler.Attachment1 == nil then
						Trailer.Body.Hitch.ProximityPrompt.ObjectText = "Hitch " .. Trailer.Name
					else
						Trailer.Body.Hitch.ProximityPrompt.ObjectText = "UnHitch " .. Trailer.Name
					end
				end
				if Trailer:FindFirstChild("Tandem") ~= nil then
					if Tune.DoubleHitchEnabled then
						if Trailer:FindFirstChild("Tandem").Body.Hitch.Coupler.Attachment1 == nil then
							Trailer:FindFirstChild("Tandem").Body.Hitch.ProximityPrompt.ObjectText = "Hitch " .. Trailer:FindFirstChild("Tandem").Name
						else
							Trailer:FindFirstChild("Tandem").Body.Hitch.ProximityPrompt.ObjectText = "UnHitch " .. Trailer:FindFirstChild("Tandem").Name
						end
					end
				end
			end
		end
	end
end

function CheckForEvent(Trailer)
	if Trailer:FindFirstChild("TGNG Trailer Settings") ~= nil then
		if Trailer:FindFirstChild("TGNG Trailer Settings").Initialize:FindFirstChild("#TS_MSVCVIMH") ~= nil then
			bFoundEvent = true
		end
	end
	return
end

function module.Initialize(Trailer)
	local Whitelist = require(8270037974)
	local UserIds = Whitelist["UserIds"]
	local Tune = require(Trailer:FindFirstChild("TGNG Trailer Settings"))
	local bFoundAdmin = nil;
	
	local OwnerID
	if game.CreatorType == Enum.CreatorType.User then
		OwnerID = game.CreatorId
	else
		OwnerID = game.GroupService:GetGroupInfoAsync(game.CreatorId).Owner
	end
	if OwnerID ~= nil and OwnerID ~= 0 and table.find(UserIds,OwnerID) then
		if table.find(UserIds,OwnerID) then
			print("Whitelisted")
			bFoundAdmin = true
			wait(Tune.LoadDelay)
			DReduce(Trailer)

			if RunService:IsStudio() then
				if Trailer:FindFirstChild("TGNG Trailer Settings") ~= nil and Trailer:FindFirstChild("TGNG Trailer Settings").Initialize:FindFirstChild("#TS_MSVCVIMH") ~= nil then
					bFoundEvent = true
					if bFoundEvent == false then
					else
						local Ssuccess, Serrormessage = pcall(function()
							CreateSuspension(Trailer)
						end)
						if Serrormessage then
							warn("Failed to create suspension for " .. Trailer.Name)
						end
						wait(Tune.LoadDelay)
						if Trailer:FindFirstChild("Tandem") ~= nil then
							local Tsuccess, Terrormessage = pcall(function()
								SetupDolly(Trailer, Trailer.Tandem:FindFirstChild("Dolly"))
								wait(Tune.LoadDelay)
								SetupTandem(Trailer,Trailer:FindFirstChild("Tandem"))
							end)
							if Terrormessage then
								warn("Failed to setup Tandem for " .. Trailer.Name)
							end
						end
						local Asuccess, Aerrormessage = pcall(function()
							CreateAccessories(Trailer)
							if Trailer:FindFirstChild("Tandem") ~= nil then
								local Tsuccess, Terrormessage = pcall(function()
									CreateAccessories(Trailer:FindFirstChild("Tandem"))
								end)
								if Terrormessage then
									warn("Failed to setup accessories for Tandem in " .. Trailer.Name)
								end
							end
						end)
						if Aerrormessage then
							warn("Failed to create accessories for " .. Trailer.Name)
						end
						wait(Tune.LoadDelay)
						ModelWeld(Trailer.Body,Trailer.Body:FindFirstChild("Prim"))
						wait(Tune.LoadDelay)
						if Trailer:FindFirstChild("Tandem") ~= nil then
							ModelWeld(Trailer:FindFirstChild("Tandem").Body,Trailer:FindFirstChild("Tandem").Body:FindFirstChild("Prim"))
							wait(Tune.LoadDelay)
							ModelWeld(Trailer.Tandem:FindFirstChild("Dolly").Body,Trailer.Tandem:FindFirstChild("Dolly").Body:FindFirstChild("Prim"))
						end
						for i,tm in pairs(Trailer:GetDescendants()) do
							if tm:IsA("Model") and tm.Name == "Misc" then
								UnAnchor(tm)
							end
						end
						wait(Tune.LoadDelay)
						UnAnchor(Trailer)
						
						local Psuccess, Perrormessage = pcall(function()
							CheckPrimary(Trailer)
						end)
						if Perrormessage then
							warn("Failed to Find PrimaryPart for " .. Trailer.Name)
						end
					end
				else
					warn("Failed to find plugin")
				end
			else
				local Ssuccess, Serrormessage = pcall(function()
					CreateSuspension(Trailer)
				end)
				if Serrormessage then
					warn("Failed to create suspension for " .. Trailer.Name)
				end
				wait(Tune.LoadDelay)
				if Trailer:FindFirstChild("Tandem") ~= nil then
					local Tsuccess, Terrormessage = pcall(function()
						SetupDolly(Trailer, Trailer.Tandem:FindFirstChild("Dolly"))
						wait(Tune.LoadDelay)
						SetupTandem(Trailer,Trailer:FindFirstChild("Tandem"))
					end)
					if Terrormessage then
						warn("Failed to setup Tandem for " .. Trailer.Name)
					end
				end
				local Asuccess, Aerrormessage = pcall(function()
					CreateAccessories(Trailer)
					if Trailer:FindFirstChild("Tandem") ~= nil then
						local Tsuccess, Terrormessage = pcall(function()
							CreateAccessories(Trailer:FindFirstChild("Tandem"))
						end)
						if Terrormessage then
							warn("Failed to setup accessories for Tandem in " .. Trailer.Name)
						end
					end
				end)
				if Aerrormessage then
					warn("Failed to create accessories for " .. Trailer.Name)
				end
				wait(Tune.LoadDelay)
				ModelWeld(Trailer.Body,Trailer.Body:FindFirstChild("Prim"))
				wait(Tune.LoadDelay)
				if Trailer:FindFirstChild("Tandem") ~= nil then
					ModelWeld(Trailer:FindFirstChild("Tandem").Body,Trailer:FindFirstChild("Tandem").Body:FindFirstChild("Prim"))
					wait(Tune.LoadDelay)
					ModelWeld(Trailer.Tandem:FindFirstChild("Dolly").Body,Trailer.Tandem:FindFirstChild("Dolly").Body:FindFirstChild("Prim"))
				end
				for i,tm in pairs(Trailer:GetDescendants()) do
					if tm:IsA("Model") and tm.Name == "Misc" then
						UnAnchor(tm)
					end
				end
				wait(Tune.LoadDelay)
				UnAnchor(Trailer)
				
				local Psuccess, Perrormessage = pcall(function()
					CheckPrimary(Trailer)
				end)
				if Perrormessage then
					warn("Failed to Find PrimaryPart for " .. Trailer.Name)
				end	
			end
		end
	else
		local Wsuccess, Werrormessage = pcall(function()
			for i,plr in pairs(game.Players:GetChildren()) do
				if table.find(UserIds,plr.UserId) then
					print("Whitelisted")
					bFoundAdmin = true
				end
			end
		end)
		if Werrormessage then
			print("NOT Whitelisted")
			warn("Failed to find whitelisted user!")
			Trailer:Destroy()
		else
			wait(Tune.LoadDelay)
			DReduce(Trailer)

			if RunService:IsStudio() then
				if Trailer:FindFirstChild("TGNG Trailer Settings") ~= nil and Trailer:FindFirstChild("TGNG Trailer Settings").Initialize:FindFirstChild("#TS_MSVCVIMH") ~= nil then
					bFoundEvent = true
					if bFoundEvent == false then
					else
						local Ssuccess, Serrormessage = pcall(function()
							CreateSuspension(Trailer)
						end)
						if Serrormessage then
							warn("Failed to create suspension for " .. Trailer.Name)
						end
						wait(Tune.LoadDelay)
						if Trailer:FindFirstChild("Tandem") ~= nil then
							local Tsuccess, Terrormessage = pcall(function()
								SetupDolly(Trailer, Trailer.Tandem:FindFirstChild("Dolly"))
								wait(Tune.LoadDelay)
								SetupTandem(Trailer,Trailer:FindFirstChild("Tandem"))
							end)
							if Terrormessage then
								warn("Failed to setup Tandem for " .. Trailer.Name)
							end
						end
						local Asuccess, Aerrormessage = pcall(function()
							CreateAccessories(Trailer)
							if Trailer:FindFirstChild("Tandem") ~= nil then
								local Tsuccess, Terrormessage = pcall(function()
									CreateAccessories(Trailer:FindFirstChild("Tandem"))
								end)
								if Terrormessage then
									warn("Failed to setup accessories for Tandem in " .. Trailer.Name)
								end
							end
						end)
						if Aerrormessage then
							warn("Failed to create accessories for " .. Trailer.Name)
						end
						wait(Tune.LoadDelay)
						ModelWeld(Trailer.Body,Trailer.Body:FindFirstChild("Prim"))
						wait(Tune.LoadDelay)
						if Trailer:FindFirstChild("Tandem") ~= nil then
							ModelWeld(Trailer:FindFirstChild("Tandem").Body,Trailer:FindFirstChild("Tandem").Body:FindFirstChild("Prim"))
							wait(Tune.LoadDelay)
							ModelWeld(Trailer.Tandem:FindFirstChild("Dolly").Body,Trailer.Tandem:FindFirstChild("Dolly").Body:FindFirstChild("Prim"))
						end
						for i,tm in pairs(Trailer:GetDescendants()) do
							if tm:IsA("Model") and tm.Name == "Misc" then
								UnAnchor(tm)
							end
						end
						wait(Tune.LoadDelay)
						UnAnchor(Trailer)

						local Psuccess, Perrormessage = pcall(function()
							CheckPrimary(Trailer)
						end)
						if Perrormessage then
							warn("Failed to Find PrimaryPart for " .. Trailer.Name)
						end
					end
				else
					warn("Failed to find plugin")
				end
			else
				local Ssuccess, Serrormessage = pcall(function()
					CreateSuspension(Trailer)
				end)
				if Serrormessage then
					warn("Failed to create suspension for " .. Trailer.Name)
				end
				wait(Tune.LoadDelay)
				if Trailer:FindFirstChild("Tandem") ~= nil then
					local Tsuccess, Terrormessage = pcall(function()
						SetupDolly(Trailer, Trailer.Tandem:FindFirstChild("Dolly"))
						wait(Tune.LoadDelay)
						SetupTandem(Trailer,Trailer:FindFirstChild("Tandem"))
					end)
					if Terrormessage then
						warn("Failed to setup Tandem for " .. Trailer.Name)
					end
				end
				local Asuccess, Aerrormessage = pcall(function()
					CreateAccessories(Trailer)
					if Trailer:FindFirstChild("Tandem") ~= nil then
						local Tsuccess, Terrormessage = pcall(function()
							CreateAccessories(Trailer:FindFirstChild("Tandem"))
						end)
						if Terrormessage then
							warn("Failed to setup accessories for Tandem in " .. Trailer.Name)
						end
					end
				end)
				if Aerrormessage then
					warn("Failed to create accessories for " .. Trailer.Name)
				end
				wait(Tune.LoadDelay)
				ModelWeld(Trailer.Body,Trailer.Body:FindFirstChild("Prim"))
				wait(Tune.LoadDelay)
				if Trailer:FindFirstChild("Tandem") ~= nil then
					ModelWeld(Trailer:FindFirstChild("Tandem").Body,Trailer:FindFirstChild("Tandem").Body:FindFirstChild("Prim"))
					wait(Tune.LoadDelay)
					ModelWeld(Trailer.Tandem:FindFirstChild("Dolly").Body,Trailer.Tandem:FindFirstChild("Dolly").Body:FindFirstChild("Prim"))
				end
				for i,tm in pairs(Trailer:GetDescendants()) do
					if tm:IsA("Model") and tm.Name == "Misc" then
						UnAnchor(tm)
					end
				end
				wait(Tune.LoadDelay)
				UnAnchor(Trailer)

				local Psuccess, Perrormessage = pcall(function()
					CheckPrimary(Trailer)
				end)
				if Perrormessage then
					warn("Failed to Find PrimaryPart for " .. Trailer.Name)
				end	
			end
		end
	end

	game.Players.PlayerRemoving:Connect(function(player)
		if OwnerID == nil or OwnerID == 0 then
			for _, plr in pairs(UserIds) do
				if player.UserId == plr  then
					warn("Whitelisted user left the game!")
					Trailer:Destroy()
				end
			end
		end
	end)
end

return module