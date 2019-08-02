--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

Player = Class{__includes = Entity}

function Player:init(def)
    Entity.init(self, def)
    self.room = nil
    self.pot = nil
end

function Player:update(dt)
    Entity.update(self, dt)

    if self.pot ~= nil then
      self.pot.x = self.x
      self.pot.y = self.y - 12
    end
end

function Player:collides(target)
    local selfY, selfHeight = self.y + self.height / 2, self.height - self.height / 2

    return not (self.x + self.width < target.x or self.x > target.x + target.width or
                selfY + selfHeight < target.y or selfY > target.y + target.height)
end



function Player:fire()

  if self.pot ~= nil then
    self.pot:fire(self.direction)
    self.pot = nil
    self:changeState('walk')
  end

end



function Player:dropBomb(room)


  local bomb = GameObject(GAME_OBJECT_DEFS['bomb'], self.x, self.y)
  bomb.onAnimationOver = function()
      bomb.dead = true
      gSounds['explosion']:play()
      local bombexploding = GameObject(GAME_OBJECT_DEFS['bombexploding'], bomb.x, bomb.y)
      bombexploding.onAnimationOver = function()
        bombexploding.dead = true
      end
      bombexploding:changeAnimation('explode')
      table.insert(room.objects, bombexploding)
  end
  bomb:changeAnimation('explode')

  table.insert(room.objects, bomb)
end


function Player:checkPickup(room)

  if self.direction == 'right' then
    self.x = self.x + 5
    self:checkForSolidObject(room.objects)
    self.x = self.x - 5
  elseif self.direction == 'left' then
    self.x = self.x - 5
    self:checkForSolidObject(room.objects)
    self.x = self.x + 5
  elseif self.direction == 'up' then
    self.y = self.y - 5
    self:checkForSolidObject(room.objects)
    self.y = self.y + 5
  elseif self.direction == 'down' then
    self.y = self.y + 5
    self:checkForSolidObject(room.objects)
    self.y = self.y - 5
  end
end


function Player:checkForSolidObject(objects)

  for k, object in pairs(objects) do
      if object.solid and self:collides(object) then
        self:changeState('pickup')
        self.pot = object
      end
  end
end


function Player:render()
    Entity.render(self)

    -- love.graphics.setColor(255, 0, 255, 255)
    -- love.graphics.rectangle('line', self.x, self.y, self.width, self.height)
    -- love.graphics.setColor(255, 255, 255, 255)
end
