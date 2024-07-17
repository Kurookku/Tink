local RunService = game:GetService("RunService")

if RunService:IsServer() then
	return require(script:WaitForChild("TinkServer"))
else
	script:WaitForChild("TinkServer"):Destroy()

	return require(script:WaitForChild("TinkClient"))
end