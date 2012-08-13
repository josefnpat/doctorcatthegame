require("TEsound")
TEsound.playLooping("assets/pk-strangerdanger-final.ogg", "music")
love.mouse.setVisible( false )
function love.load()
  bg = {}
  bg[0] = love.graphics.newImage("assets/bg0.png")
  bg[1] = love.graphics.newImage("assets/bg1.png")
  bg[2] = love.graphics.newImage("assets/bg2.png")
  bg[3] = love.graphics.newImage("assets/bg3.png")

  img_ghostcat = love.graphics.newImage("assets/ghostcat.png")
  img_coin = love.graphics.newImage("assets/coin.png")
  img_crap = love.graphics.newImage("assets/crap.png")
  img_lawyercat = love.graphics.newImage("assets/lawyercat.png");
  img_sarah_backward = love.graphics.newImage("assets/sarah_backward.png")
  img_sarah_forward = love.graphics.newImage("assets/sarah_forward.png")
  img_pk = love.graphics.newImage("assets/pk.jpg")
  img_key = {}
  img_key[1] = love.graphics.newImage("assets/key_1.png")
  --img_key[1.5] = love.graphics.newImage("assets/key_1.5.png")
  --img_key[2] = love.graphics.newImage("assets/key_2.png")
  img_key[3] = love.graphics.newImage("assets/key_3.png")
  
  levelcat = {}
  levelcat[1] = {}
  levelcat[1].stand = love.graphics.newImage("assets/whitecat_1.png")
  levelcat[1].move = love.graphics.newImage("assets/whitecat_2.png")
  levelcat[2] = {}
  levelcat[2].stand = love.graphics.newImage("assets/fatcat_1.png")
  levelcat[2].move = love.graphics.newImage("assets/fatcat_2.png")
  levelcat[3] = {}
  levelcat[3].stand = love.graphics.newImage("assets/doctorcat_1.png")
  levelcat[3].move = love.graphics.newImage("assets/doctorcat_2.png")
  current_level = 1
  playercat = {}
  playercat.stand = love.graphics.newImage("assets/standing.png")
  playercat.move_left = love.graphics.newImage("assets/left.png")
  playercat.move_right = love.graphics.newImage("assets/right.png")

  title_font = love.graphics.newFont("assets/font.ttf",128)
  text_font = love.graphics.newFont("assets/font.ttf",64)
  key_font = love.graphics.newFont("assets/font.ttf",48)

  title_cat = love.graphics.newImage("assets/title.png")
  title_dt = 0
  state = "title"

  rate_coins_dt = 0
  life_coins = 4
  
  rate_craps_dt = 0
  life_craps = 10
  
  rate_ghostcats_dt = 0
  life_ghostcats = 9

  cat = {}
  cat.x = 400
  cat.y = 400
  cat.jumping = false
  cat.img = playercat.stand
  cat.facing = "left"
  cat.rad = 100
  cat.coins = 0
  cat.level_coins = {}
  cat.level_fail = {}
  cat.level_coins[1] = 0
  cat.level_coins[2] = 0
  cat.level_coins[3] = 0
  
  level_init()
end

function love.draw()
  if state == "title" then
    love.graphics.draw(bg[0],0,0)
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont(title_font)
    love.graphics.printf("Doctor Cat: The Game",0,48,800,"center")
    love.graphics.setFont(text_font)
    love.graphics.printf("a game about a cat who is also a doctor",0,136,800,"center")
    love.graphics.printf("Press space!",0,136+40,800,"center")
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(title_cat,400,400,math.sin(title_dt)/4,1,1,200,150)
  elseif state == "quit" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.setFont(text_font)
    love.graphics.draw(img_pk,0,0)
    love.graphics.draw(img_lawyercat,600-img_lawyercat:getWidth()/2,550-img_lawyercat:getHeight())
    love.graphics.printf("Thank you for playing!\ndoctor cat: doctorcatmd.com\ncode: josefnpat.com\nframework: Love2d.org\nmusic: jimdewitt.tumblr.com",420,20,360,"center")
  elseif state == "intro" then
    love.graphics.draw(bg[0],0,0)
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont(title_font)
    love.graphics.printf("How To Play",0,96,800,"center")
    love.graphics.setFont(text_font)
    love.graphics.printf("Use the wasd keys to control your cat!",0,232,800,"center")
    love.graphics.setColor(255,255,255,255)
    local key_x = 90
    local key_y = 350-17
    love.graphics.draw(img_key[1],64+key_x,key_y,0,.5)
    love.graphics.draw(img_key[1],key_x,64+key_y,0,.5)
    love.graphics.draw(img_key[1],64+key_x,64+key_y,0,.5)    
    love.graphics.draw(img_key[1],128+key_x,64+key_y,0,.5)
    love.graphics.draw(img_key[3],key_x,128+key_y,0,.5)
    love.graphics.setFont(key_font)
    love.graphics.setColor(0,0,0,255)
    love.graphics.printf("W",64+key_x,key_y,64,"center")
    love.graphics.printf("S",64+key_x,64+key_y,64,"center")
    love.graphics.printf("A",key_x,64+key_y,64,"center")
    love.graphics.printf("D",128+key_x,64+key_y,64,"center")
    love.graphics.printf("SPACE",key_x,128+key_y,192,"center")
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(img_coin,400,360,0,1,1,33,33)
    love.graphics.draw(img_ghostcat,400,430,0,1,1,32,24)
    love.graphics.draw(img_crap,400,500,0,1,1,27,37)
    love.graphics.setColor(0,0,0,255)
    love.graphics.print("Cat quarters: Collect me! (+1)",450,360-35)
    love.graphics.print("Cat ghost: Avoid me! (-4)",450,430-35)
    love.graphics.print("Cat crap: Ewwww! (-16)",450,500-35)
    love.graphics.setColor(255,255,255,255)
  elseif state == "game" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(bg[current_level],0,0)
    for i,v in ipairs(craps) do
      if v.time + life_craps > love.timer.getMicroTime() then
        if v.time + life_craps - 1 < love.timer.getMicroTime() then
          if (love.timer.getMicroTime()*1000)%240 > 120 then
            love.graphics.draw(img_crap,v.x,v.y,0,-1+(2*v.rot),1,27,37)
          end
        else
          love.graphics.draw(img_crap,v.x,v.y,0,-1+(2*v.rot),1,27,37)
        end
      end
    end
    for i,v in ipairs(coins_lost) do
      love.graphics.draw(img_coin,v.x,v.y,0,0.5,0.5,img_coin:getWidth()/2,img_coin:getWidth()/2)
    end
    love.graphics.setColor(255,255,255,255)
    if scamper_for_level then
      local temp_frame = love.timer.getMicroTime()*1000%480
      if temp_frame > 360 then
        love.graphics.draw(scamper_for_level.img.stand,scamper_for_level.x,scamper_for_level.y,0,1,1,scamper_for_level.img.stand:getWidth()/2)
      elseif temp_frame > 240 then
        love.graphics.draw(scamper_for_level.img.move,scamper_for_level.x,scamper_for_level.y,0,1,1,scamper_for_level.img.move:getWidth()/2)
      elseif temp_frame > 120 then
        love.graphics.draw(scamper_for_level.img.stand,scamper_for_level.x,scamper_for_level.y,0,-1,1,scamper_for_level.img.stand:getWidth()/2)
      else -- temp_frame <= 120
        love.graphics.draw(scamper_for_level.img.move,scamper_for_level.x,scamper_for_level.y,0,-1,1,scamper_for_level.img.move:getWidth()/2)
      end
    end
    local jrot = 0
    if cat.jumping and cat.timeleft < 0 then
      jrot = cat.jumping / 180 * math.pi*2
    end
    if cat.facing == "left" then
      love.graphics.draw(cat.img,cat.x,cat.y,jrot,1,1,150,150)
    else
      love.graphics.draw(cat.img,cat.x,cat.y,jrot,-1,1,150,150)
    end
    
    --love.graphics.circle("line",cat.x,cat.y,100,100) --cat intersection debug
    
    for i,v in ipairs(coins) do
      if v.time + life_coins > love.timer.getMicroTime() then
        if v.time + life_coins - 1 < love.timer.getMicroTime() then
          if (love.timer.getMicroTime()*1000)%240 > 120 then
            love.graphics.draw(img_coin,v.x,v.y,v.rot,1,1,33,33)
          end
        else
          love.graphics.draw(img_coin,v.x,v.y,v.rot,1,1,33,33)
        end
      end
    end
    for i,v in ipairs(ghostcats) do
      if v.time + life_ghostcats > love.timer.getMicroTime() then
        love.graphics.draw(img_ghostcat,v.x,v.y,v.rot+math.sin(love.timer.getMicroTime()-v.time),v.v_x/100,1,32,24)
      end
    end
    draw_overlay()
    love.graphics.setColor(0,0,0,255)
  elseif state == "gameover" then
    love.graphics.setColor(255,255,255,255)
    love.graphics.draw(bg[0],0,0)
    love.graphics.setColor(0,0,0,255)
    love.graphics.setFont(title_font)
    love.graphics.printf("Game Over!",0,48,800,"center")
    love.graphics.setFont(text_font)
    love.graphics.printf("Total Collected: $"..string.format("%.2f",(cat.level_coins[1]+cat.level_coins[2]+cat.level_coins[3])/4),0,136,800,"center")
    local temp_frame = love.timer.getMicroTime()*1000%480
    for i = 1,3 do
      local i_x = 600 * i / 3 - 100
      local i_y = 330
      love.graphics.setColor(0,0,0,255)
      love.graphics.printf("LEVEL"..i,i_x,i_y-96-8,200,"center")
      if not cat.level_fail[i] then
        love.graphics.printf("$"..string.format("%.2f",cat.level_coins[i]/4),i_x,i_y-64,200,"center")
        love.graphics.setColor(255,255,255,255)
        if i == 2 then
          i_x = i_x - 25 -- GOD DAMN FAT CAT.
        end
        if temp_frame > 360 then
          love.graphics.draw(levelcat[i].stand,i_x+levelcat[i].stand:getWidth()/2,i_y,0,1,1,levelcat[i].stand:getWidth()/2)
        elseif temp_frame > 240 then
          love.graphics.draw(levelcat[i].move,i_x+levelcat[i].move:getWidth()/2,i_y,0,1,1,levelcat[i].move:getWidth()/2)        
        elseif temp_frame > 120 then
          love.graphics.draw(levelcat[i].stand,i_x+levelcat[i].stand:getWidth()/2,i_y,0,-1,1,levelcat[i].stand:getWidth()/2)
        else -- temp_frame <= 120
          love.graphics.draw(levelcat[i].move,i_x+levelcat[i].move:getWidth()/2,i_y,0,-1,1,levelcat[i].move:getWidth()/2)        
        end
      else
        love.graphics.printf("FAIL",i_x,i_y-64,200,"center")
        love.graphics.setColor(255,255,255,255)
        if temp_frame > 360 then
          love.graphics.draw(img_sarah_forward,i_x+img_sarah_forward:getWidth()/2,i_y,0,1,1,img_sarah_forward:getWidth()/2)
        elseif temp_frame > 240 then
          love.graphics.draw(img_sarah_backward,i_x+img_sarah_backward:getWidth()/2,i_y,0,1,1,img_sarah_backward:getWidth()/2)        
        elseif temp_frame > 120 then
          love.graphics.draw(img_sarah_forward,i_x+img_sarah_forward:getWidth()/2,i_y,0,-1,1,img_sarah_forward:getWidth()/2)
        else -- temp_frame <= 120
          love.graphics.draw(img_sarah_backward,i_x+img_sarah_backward:getWidth()/2,i_y,0,-1,1,img_sarah_backward:getWidth()/2)        
        end
      end
    end
  end
end

function love.update(dt)
  TEsound.cleanup()
  if state == "title" then
    title_dt = (title_dt + dt) % (math.pi*2)
  elseif state == "game" then
    
    cat.timeleft = cat.timeleft - dt
    
    if not scamper_for_level and cat.timeleft <= 0 then
      scamper_for_level = {
        x = -150,
        y = 270,
        img = levelcat[current_level]
      }
      TEsound.play("assets/level"..current_level..".ogg")
    end
    
    if scamper_for_level then
      scamper_for_level.x = scamper_for_level.x + 3*210*dt
    end
    
    if cat.timeleft < -5 then
      if cat.level_fail[current_level] then
        cat.level_coins[current_level] = 0      
      else
        cat.level_coins[current_level] = cat.coins
      end
      cat.coins = 0
      if current_level < 3 then
        current_level = current_level + 1
        level_init()
      else
        state = "gameover"
      end
    end
    
    -- COINS
    
    rate_coins_dt = rate_coins_dt + dt
    if rate_coins_dt >= rate_coins and cat.timeleft > 0 then
      rate_coins_dt = 0
      local coin = {
        x = math.random(0,800),
        y = math.random(0,400),
        time = love.timer.getMicroTime(),
        rot = math.random(-1,1)
      }
      table.insert(coins,coin)
    end
    
    for i,v in ipairs(coins) do
      if v.time + life_coins < love.timer.getMicroTime() then
        table.remove(coins,i)
      end
      if distance(cat,v)<cat.rad then
        table.remove(coins,i)
        cat.coins = cat.coins + 1
        TEsound.play("assets/coin.ogg")
      end
    end
    
    -- CRAPS
    
    rate_craps_dt = rate_craps_dt + dt
    if rate_craps_dt >= rate_craps and cat.timeleft > 0 then
      rate_craps_dt = 0
      local crap = {
        x = math.random(0,800),
        y = -33,
        time = love.timer.getMicroTime(),
        rot = math.random(0,1)
      }
      table.insert(craps,crap)
    end
    
    for i,v in ipairs(craps) do
      if v.time + life_craps < love.timer.getMicroTime() then
        table.remove(craps,i)
      end
      if v.y < 470 then
        v.y = v.y + 100*dt
      else
        v.y = 470
      end
      if distance(cat,v)<cat.rad then
        table.remove(craps,i)
        add_coins_lost(16)
        TEsound.play("assets/coins_lost_crap.ogg")
      end
    end
    
    -- GHOSTCATS
    
    rate_ghostcats_dt = rate_ghostcats_dt + dt
    if rate_ghostcats_dt >= rate_ghostcats and cat.timeleft > 0 then
      rate_ghostcats_dt = 0
      local dir = math.random(0,1)
      local ghostcat = {
        x = dir*866-33,
        y = math.random(1,4)*100,
        time = love.timer.getMicroTime(),
        rot = 0,
        v_x = dir*-200+100
      }
      table.insert(ghostcats,ghostcat)
    end
    
    for i,v in ipairs(ghostcats) do
      if v.time + life_ghostcats < love.timer.getMicroTime() then
        table.remove(ghostcats,i)
      end
      v.x = v.x + v.v_x * dt
      if distance(cat,v)<cat.rad then
        table.remove(ghostcats,i)
        add_coins_lost(4)
          TEsound.play("assets/coins_lost_ghostcat.ogg")
      end
    end
    
    -- MOVEMENT (JUMPING AND WALKING)
    
    if key_pressed.w then
      if not cat.jumping then
        cat.jumping = 0
        TEsound.play("assets/jump.ogg")
      end
    end
    if cat.jumping then
      cat.jumping = cat.jumping + dt*200
      if cat.jumping < 180 then
        cat.y = 400 - 300*math.sin(cat.jumping / 180 * math.pi)^0.5
      else
        cat.jumping = false
        cat.y = 400
      end
    end
    if key_pressed.a then
      cat.x = cat.x - 400*dt
      cat.facing = "left"
    end
    if key_pressed.d then
      cat.x = cat.x + 400*dt
      cat.facing = "right"
    end
    if key_pressed.s then
      if cat.jumping and cat.jumping > 90 then
        cat.jumping = cat.jumping + dt*400
      end
    end
    
    -- PLAYER GRAPHICS
    
    if (key_pressed.a or key_pressed.d) and not cat.jumping then
      local temp_frame = (love.timer.getMicroTime()*1000)%480
      if temp_frame > 320 then
        cat.img = playercat.move_right
      elseif temp_frame > 240 then
        cat.img = playercat.stand
      elseif temp_frame > 120 then
        cat.img = playercat.move_left
      else -- temp_frame <= 120
        cat.img = playercat.stand
      end
    else
      if cat.jumping then
        cat.img = playercat.move_left
      else
        cat.img = playercat.stand
      end
    end
    
    -- LOOP CAT
    
    --[[
    
    if cat.x <= -50 then
      cat.x = 800 + 50
    end
    if cat.x > 800 + 50 then
      cat.x = -50
    end
    
    --]]
    
    -- STOP CAT
    
    if cat.x <= 0 then
      cat.x = 0
    end
    if cat.x > 800 then
      cat.x = 800
    end
    
    for i,v in ipairs(coins_lost) do
      if v.y > 650 then
        table.remove(coins_lost,i)
      else
        v.x = v.x + math.sin(v.dir)*100*dt
        v.y = v.y + math.abs(math.cos(v.dir)*100*dt) + 1
      end
    end
    
  end
end

function distance(a,b)
  return math.sqrt((a.x-b.x)^2 + (a.y-b.y)^2)
end

function draw_overlay()
  love.graphics.setColor(0,0,0,255)
  if cat.timeleft < 0 and current_level ~= 3 then
    love.graphics.printf("NEXT LEVEL IN "..string.format("%.0f",5-math.abs(cat.timeleft)),0,514-8,800,"center")      
  else
    love.graphics.printf("LEVEL "..current_level,0,514-8,800,"center")
  end
  love.graphics.printf("$"..string.format("%.2f",cat.coins/4),0,550-8,150,"center")
  if cat.timeleft > 0 then
    love.graphics.printf(string.format("%.0f",cat.timeleft).."s",650,550-8,150,"center")
  end
  local coinw = img_coin:getWidth()/2
  local spacing = (800-300-coinw) / cat.coins
  if spacing > coinw then
    spacing = coinw
  end
  love.graphics.setColor(255,255,255,255)
  for i = 1,cat.coins do
    love.graphics.draw(img_coin,150+i*spacing,550,0,0.5,0.5,0,0)
  end
end

coins_lost = {}
function add_coins_lost(x)
  if cat.coins < x then
    x = cat.coins
    cat.coins = 0
    cat.timeleft = 0
    cat.level_fail[current_level] = true
  else
    cat.coins = cat.coins - x
  end
  for i = 1,x do
    local coin = {
      x = cat.x,
      y = cat.y,
      dir = math.random(1,360)
    }
    table.insert(coins_lost,coin)
  end
end

function level_init()
  scamper_for_level = nil
  cat.timeleft = 60
  coins = {}
  craps = {}
  ghostcats = {}
  if current_level == 1 then
    rate_coins = 2
    rate_craps = 32
    rate_ghostcats = 8
  elseif current_level == 2 then
    rate_coins = 1
    rate_craps = 16
    rate_ghostcats = 4
  else -- level 3
    rate_coins = 0.5
    rate_craps = 8
    rate_ghostcats = 2
  end
end

-- KEYS

key_pressed = {}
key_pressed.w = false;
key_pressed.s = false;
key_pressed.a = false;
key_pressed.d = false;
key_pressed.space = false;
function love.keypressed(key)
  if key == "escape" then
    if state == "quit" then
      love.event.push("q")    
    else
      state = "quit"
    end
  elseif key == "f11" then
    love.graphics.toggleFullscreen()
  elseif key == "w" then
    key_pressed.w = true
  elseif key == "a" then
    key_pressed.a = true
  elseif key == "s" then
    key_pressed.s = true
  elseif key == "d" then
    key_pressed.d = true
  elseif key == " " then
    if state == "title" then
      love.load()
      state = "intro"
    elseif state == "intro" then
      state = "game"
    elseif state == "game" then
      -- Wheee!
    elseif state == "gameover" then
      state = "title"
    end
  end
end

function love.keyreleased(key)
  if key == "w" then
    key_pressed.w = false
  elseif key == "a" then
    key_pressed.a = false
  elseif key == "s" then
    key_pressed.s = false
  elseif key == "d" then
    key_pressed.d = false
  end
end
