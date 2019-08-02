--[[
    GD50
    Legend of Zelda

    Author: Colton Ogden
    cogden@cs50.harvard.edu
]]

GAME_OBJECT_DEFS = {
    ['switch'] = {
        type = 'switch',
        texture = 'switches',
        frame = 2,
        width = 16,
        height = 16,
        solid = false,
        isProjectile = false,
        damagesPlayer = false,
        consumable = false,
        defaultState = 'unpressed',
        states = {
            ['unpressed'] = {
                frame = 2
            },
            ['pressed'] = {
                frame = 1
            }
        },
        animations = {}
    },
    ['pot'] = {
      type = 'pot',
      texture = 'tiles',
      frame = 14,
      width = 16,
      height = 16,
      solid = true,
      isProjectile = false,
      damagesPlayer = false,
      consumable = false,
      defaultState = 'idle',
      states = {
          ['idle'] = {
              frame = 14
          }
      },
      animations = {}
    },
    ['heart'] = {
        type = 'heart',
        texture = 'hearts',
        frame = 5,
        width = 16,
        height = 16,
        solid = false,
        isProjectile = false,
        damagesPlayer = false,
        consumable = true,
        defaultState = 'solid',
        states = {
            ['solid'] = {
                frame = 5
            }
        },
        animations = {}
      },
      ['bomb'] = {
          type = 'bomb',
          texture = 'bomb',
          frame = 1,
          width = 16,
          height = 16,
          solid = false,
          isProjectile = false,
          damagesPlayer = false,
          consumable = false,
          defaultState = 'idle',
          states = {
              ['idle'] = {
                  frame = 1
              }
          },
          animations = {
              ['explode'] = {
                  frames = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},
                  interval = 0.155,
                  texture = 'bomb',
                  looping = false
              }
          }
        },
        ['bombexploding'] = {
            type = 'bombexploding',
            texture = 'bombexploding',
            frame = 1,
            width = 32,
            height = 32,
            solid = false,
            isProjectile = true,
            damagesPlayer = true,
            consumable = false,
            defaultState = 'idle',
            states = {
                ['idle'] = {
                    frame = 1
                }
            },
            animations = {
                ['explode'] = {
                    frames = {1, 2, 3, 4, 5, 6, 7},
                    interval = 0.155,
                    texture = 'bombexploding',
                    looping = false
                }
            }
          }
}
