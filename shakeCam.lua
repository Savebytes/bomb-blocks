local shakeCam = {}

function shakeCam:new()
    local object = {}
    object.t, object.shakeDuration, object.shakeMagnitude = 0, -1, 0

    return setmetatable(object, {__index = self})
end

function shakeCam:update(dt)
    if self.t < self.shakeDuration then
		self.t = self.t + dt
	end
end

function shakeCam:draw()
    if self.t < self.shakeDuration then
		local dx = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)
		local dy = love.math.random(-self.shakeMagnitude, self.shakeMagnitude)

		love.graphics.translate(dx, dy)
	end
end

function shakeCam:startShake(duration, magnitude)
	self.t, self.shakeDuration, self.shakeMagnitude = 0, duration or 1, magnitude or 5
end

return shakeCam