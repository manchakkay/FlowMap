FlowMap = {}
FlowMap.__index = FlowMap

function FlowMap:create( options )
    local map = {}

    setmetatable(map, FlowMap)

    map.size = options.size or 21
    map.margin = options.margin or 10
    map.speed = options.speed or 0.05
    map.coeffs = options.coeff or { A = 1, B = 5 }

    map.field = {}
    love.math.setRandomSeed(10000)

    return map
end

function FlowMap:init()
    local cols = (width / self.size) + self.margin
    local rows = (height / self.size) + self.margin

    for i = 1, cols do
        self.field[i] = {}
        for j = 1, rows do

            local j_corr = j - rows / 2
            local i_corr = i - cols / 2

            self.field[i][j] = Vector:create(-1 * self.coeffs.A * i_corr - self.coeffs.B * j_corr, self.coeffs.B * i_corr - self.coeffs.A * j_corr) * self.speed
        end
    end
end

function FlowMap:draw()
    for i = 1, #self.field do
        for j = 1, #self.field[1] do
            drawVector(self.field[i][j], (i - self.margin / 2) * self.size, (j - self.margin / 2) * self.size, self.size - 2)
        end
    end
end

function drawVector( v, x, y, s )
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rotate(v:heading())
    local len = v:mag() * s

    local dist = math.sqrt((width / 2 - x) ^ 2 + (height / 2 - y) ^ 2) / width

    love.graphics.setColor(1, dist, 1 - dist)
    love.graphics.line(0, 0, len, 0)
    love.graphics.setColor(0, 0, 0)
    love.graphics.circle("fill", len, 0, 2)
    love.graphics.pop()
end

function FlowMap:lookup( v )
    local col = math.constrain(math.roundNew((v.x / self.size) + self.margin / 2), 1, #self.field)
    local row = math.constrain(math.roundNew((v.y / self.size) + self.margin / 2), 1, #self.field[1])

    return self.field[col][row]:copy()
end
