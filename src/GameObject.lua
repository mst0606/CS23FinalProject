--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GameObject = Class{}

function GameObject:init(def, x, y)

    -- string identifying this object type
    self.type = def.type

    self.texture = def.texture
    self.frame = def.frame or 1

    self.animations = self:createAnimations(def.animations)

    -- whether it acts as an obstacle or not
    self.solid = def.solid

    self.defaultState = def.defaultState
    self.state = self.defaultState
    self.states = def.states

    -- dimensions
    self.x = x
    self.y = y
    self.width = def.width
    self.height = def.height
    self.dx = 0 --default movement to nothing
    self.dy = 0

    self.projectileStartData = { x = 0, y = 0, direction = '' }

    self.isProjectile = def.isProjectile
    self.damagesPlayer = def.damagesPlayer
    self.dead = false

    self.player = def.player

    self.consumable = def.consumable

    -- default empty collision callback
    self.onCollide = function() end

    -- default empty consume callback
    self.onConsume = function() end

    -- default empty consume callback
    self.onAnimationOver = function() end
end


function GameObject:createAnimations(animations)
    local animationsReturned = {}

    for k, animationDef in pairs(animations) do
        animationsReturned[k] = Animation {
            texture = animationDef.texture or 'entities',
            frames = animationDef.frames,
            interval = animationDef.interval,
            looping = animationDef.looping
        }
    end

    return animationsReturned
end


function GameObject:changeAnimation(name)
    self.currentAnimation = self.animations[name]
    self.currentAnimation.onAnimationOver = self.onAnimationOver
end


function GameObject:update(dt)

  if self.isProjectile and not self.dead then
    self.x = self.x + self.dx
    self.y = self.y + self.dy

    if self.projectileStartData.direction == 'right' then
      if self.x > self.projectileStartData.x + (TILE_SIZE * 4) then self.dead = true end
    elseif self.projectileStartData.direction == 'left' then
      if self.x < self.projectileStartData.x - (TILE_SIZE * 4) then self.dead = true end
    elseif self.projectileStartData.direction == 'up' then
      if self.y < self.projectileStartData.y - (TILE_SIZE * 4) then self.dead = true end
    elseif self.projectileStartData.direction == 'down' then
      if self.y > self.projectileStartData.y + (TILE_SIZE * 4) then self.dead = true end
    end

    if self:hitWall() then
      self.x = self.x - self.dx
      self.y = self.y - self.dy
      self.dead = true
    end
  end

  if self.currentAnimation then
      self.currentAnimation:update(dt)
  end

end



function GameObject:hitWall()

  if self.projectileStartData.direction == 'left' then

      if self.x <= MAP_RENDER_OFFSET_X + TILE_SIZE then
          return true
      end
  elseif self.projectileStartData.direction == 'right' then

      if self.x + self.width >= VIRTUAL_WIDTH - TILE_SIZE * 2 then
          return true
      end
  elseif self.projectileStartData.direction == 'up' then

      if self.y <= MAP_RENDER_OFFSET_Y + TILE_SIZE - self.height / 2 then
          return true
      end
  elseif self.projectileStartData.direction == 'down' then

      local bottomEdge = VIRTUAL_HEIGHT - (VIRTUAL_HEIGHT - MAP_HEIGHT * TILE_SIZE)
          + MAP_RENDER_OFFSET_Y - TILE_SIZE

      if self.y + self.height >= bottomEdge then
          return true
      end
  end

  return false
end



function GameObject:fire(direction)

  if self.solid and not self.isProjectile then

    --save start location, needed to compute when lands
    self.projectileStartData = { x = self.x, y = self.y, direction = direction }
    self.isProjectile = true
    self.y = self.y + self.height

    if direction == 'right' then
      self.dx = 2
    elseif direction == 'left' then
      self.dx = -2
    elseif direction == 'up' then
      self.dy = -2
    elseif direction == 'down' then
      self.dy = 2
    end
  end
end



function GameObject:render(adjacentOffsetX, adjacentOffsetY)
    if not self.dead then
      if self.currentAnimation then

        local anim = self.currentAnimation
        love.graphics.draw(gTextures[anim.texture], gFrames[anim.texture][anim:getCurrentFrame()],
            self.x + adjacentOffsetX, self.y + adjacentOffsetY)

      else
        love.graphics.draw(gTextures[self.texture], gFrames[self.texture][self.states[self.state].frame or self.frame],
          self.x + adjacentOffsetX, self.y + adjacentOffsetY)
      end
    end
end
