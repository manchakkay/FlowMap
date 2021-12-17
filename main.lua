require "vector"
require "flowmap"
require "vehicle"

function love.load()
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    love.graphics.setBackgroundColor(1, 1, 1)

    flow = FlowMap:create({ size = 45, margin = 10, speed = 0.035, coeffs = { A = 10, B = 25 } })
    flow:init()

    vehicle = Vehicle:create(width / 2, height / 2)
    vehicle.velocity.x = 1
    vehicle.velocity.y = 1
end

function love.update( dt )
    vehicle:borders()
    vehicle:follow(flow)
    vehicle:update()
end

function love.draw()
    flow:draw()
    vehicle:draw()
end
