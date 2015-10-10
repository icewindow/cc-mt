function createCloneDisplay()
  
  local nWidth, nHeight
  local nCursorX = 1
  local nCursorY = 1
  local nForegroundColor = colors.white
  local nBackgroundColor = colors.black
  local bColor = false
  local monitors = {}
  
  -- Term implementation
  local multiterm = {}

  -- Terminal implementation
  function multiterm.write( sText )
    for i=1, #monitors do
      monitors[i].write( sText )
    end
  end

  function multiterm.clear()
    for i=1, #monitors do
      monitors[i].clear()
    end
  end

  function multiterm.clearLine()
    for i=1, #monitors do
      monitors[i].clearLine()
    end
  end

  function multiterm.getCursorPos()
    return nCursorX, nCursorY
  end

  function multiterm.setCursorPos( x, y )
    nCursorX = math.floor(x)
    nCursorY = math.floor(y)
    for i=1, #monitors do
      monitors[i].setCursorPos(nCursorX, nCursorY)
    end
  end

  function multiterm.setCursorBlink( blink )
    for i=1, #monitors do
      monitors[i].setCursorBlink(blink)
    end
  end

  function multiterm.isColor()
    return bColor
  end

  function multiterm.isColour()
    return bColor
  end

  local function setTextColor( color )
    if not bColor and (color ~= colors.white and color ~= colors.black) then
      error("Color not supported by cluster!", 3)
    end
    for i=1, #monitors do
      monitors[i].setTextColor(color)
    end
  end

  function multiterm.setTextColor( color )
    setTextColor( color )
  end

  function multiterm.setTextColour( color )
    setTextColor( color )
  end

  local function setBackgroundColor( color )
    if not bColor and (color ~= colors.white and color ~= colors.black) then
      error("Color not supported by cluster!", 3)
    end
    for i=1, #monitors do
      monitors[i].setBackgroundColor(color)
    end
  end

  function multiterm.setBackgroundColor( color )
    setBackgroundColor( color )
  end

  function multiterm.setBackgroundColour( color )
    setBackgroundColor( color )
  end

  function multiterm.getSize()
    return nWidth, nHeight
  end

  function multiterm.scroll( n )
    for i=1, #monitors do
      monitors[i].scroll(n)
    end
  end
  
  -- Additional functions
  function multiterm.addTerminal( target )
    if #monitors == 0 then
      bColor = target.isColor()
      nWidth, nHeight = target.getSize()
    else
      if bColor and not target.isColor() then
        error("Cannot add non-color monitor to color cluster", 1)
      end
      local w,h = target.getSize()
      if w < nWidth or h < nHeight then
        error("Monitor is smaller than cluster!", 2)
      end
    end
    target.setCursorPos(nCursorX, nCursorY)
    target.setTextColor(nForegroundColor)
    target.setBackgroundColor(nBackgroundColor)
    table.insert(monitors, target)
  end

  return multiterm
end