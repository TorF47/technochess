--[[
Help structure and functions.

Display some help to user.
Read help content from help file.
]]

Help = {}

-- Initialize and return a new Help structure
-- @return {Help}
function Help.new()
  return {
    active = false, -- {bool} true to show help information
    text = nil, -- {string} Help text to display, nil if not yet read from file.
    filename = "assets/help.txt" -- {string} help content file
  }
end

-- Reverse display help behavior
function Help.toggle(help)
  help.active = not help.active
end

-- Draw main loop
-- return {bool} true if help is displayed, else false
function Help.draw(help)
  if help.active then
    Help.drawHelp(help)
  end

  return help.active
end

-- Draw help information
function Help.drawHelp(help)
  local r, g, b, a = love.graphics.getColor()
  local text = Help.getText(help)

  love.graphics.setColor( 0, 0, 0, 1 )
  love.graphics.setBackgroundColor( 1, 1, 1, 1 )
  love.graphics.print(text, 0, 0)
  love.graphics.setColor( r, g, b, a)
end

-- Return text to display
-- @return {String}
function Help.getText(help)
  if help.text == nil then
    help.text = Help.readTextFile(help)
  end

  return help.text
end

-- Read and return help file content.
-- @return {String}
function Help.readTextFile(help)
  local text, size = love.filesystem.read(help.filename)

  if text == nil then
    return "Help file cannot be loaded."
  end

  return text
end
