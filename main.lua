function love.load()
    anim8 = require 'libraries/anim8'
    camera = require 'libraries/camera'
    sti = require 'libraries/sti'
    wf = require 'libraries/windfield'
    world = wf.newWorld(0, 0, false)
    gameMap = sti('maps/homebase.lua')
    cam = camera()
    cam.scale = 3
    love.graphics.setDefaultFilter("nearest", "nearest")

    player = {}
    player.collider = world:newRectangleCollider(16, 16, 16, 16)
    player.collider:setFixedRotation(true)
    player.x = 16
    player.y = 16
    player.speed = 100 -- Adjust this value to control player speed
    player.spriteSheet = love.graphics.newImage('sprites/myles.png')
    player.grid = anim8.newGrid(16, 16, player.spriteSheet:getWidth(), player.spriteSheet:getHeight())
    player.animations = {}
    player.animations.down = anim8.newAnimation(player.grid('1-3', 1), 0.2)
    player.animations.left = anim8.newAnimation(player.grid('1-2', 3), 0.3)
    player.animations.right = anim8.newAnimation(player.grid('1-2', 4), 0.3)
    player.animations.up = anim8.newAnimation(player.grid('1-3', 2), 0.3)

    player.anim = player.animations.left

    background = love.graphics.newImage('sprites/background.png')

    doorway = nil

    walls = {}
    if gameMap.layers["Building"] then
        for i, obj in pairs(gameMap.layers["Building"].objects) do
            local wall = world:newRectangleCollider(obj.x,obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
    if gameMap.layers["Entrance"] then
        for i, obj in pairs(gameMap.layers["Entrance"].objects) do
            doorway = world:newRectangleCollider(obj.x,obj.y, obj.width, obj.height)
            doorway:setType('static')
        end
    end 

end

function love.update(dt)
    local isMoving = false
    local vx = 0
    local vy = 0

    if love.keyboard.isDown("right") then
        vx = player.speed
        player.anim = player.animations.right
        isMoving = true
    end
    if love.keyboard.isDown("left") then
        vx = -player.speed
        player.anim = player.animations.left
        isMoving = true
    end
    if love.keyboard.isDown("up") then
        vy = -player.speed
        player.anim = player.animations.up
        isMoving = true
    end
    if love.keyboard.isDown("down") then
        vy = player.speed
        player.anim = player.animations.down
        isMoving = true
    end

    player.collider:setLinearVelocity(vx, vy)

    if isMoving == false then
        player.anim:gotoFrame(1)
    end

    if player.collider:isTouching(doorway:getBody()) then
        local doorX, doorY = doorway:getPosition()
        player.x = doorX
        player.y = doorY

        gameMap = sti('maps/homebase_inside.lua')
        cam.x = player.x - love.graphics.getWidth() / 2
cam.y = player.y - love.graphics.getHeight() / 2
cam:zoomTo(1)
    end

    world:update(dt)
    player.x = player.collider:getX()
    player.y = player.collider:getY()
    player.anim:update(dt)
    cam:lookAt(player.x, player.y)

    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    if cam.x < w / 6 then
        cam.x = w / 6
    end
    if cam.y < h / 6 then
        cam.y = h / 6
    end

    local mapW = gameMap.width * gameMap.tilewidth
    local mapH = gameMap.height * gameMap.tileheight

    if cam.x > (mapW - w / 5) then
        cam.x = (mapW - w / 5)
    end

    if cam.y > (mapH - h / 5) then
        cam.y = (mapH - h / 5)
    end
end

function love.draw()
    cam:attach()
    love.graphics.draw(background)
    gameMap:drawLayer(gameMap.layers["Tile Layer 1"])
    gameMap:drawLayer(gameMap.layers["Tile Layer 2"])
    player.anim:draw(player.spriteSheet, player.x, player.y, nil, nil, nil, 8, 8)
    world:draw()
    cam:detach()
end