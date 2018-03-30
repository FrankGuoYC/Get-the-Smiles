-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

-- Your code here

--add physics engine
local physics = require "physics"
physics.start();
physics.setGravity( 0 , 9.8 )

--add widget library
local widget = require( "widget" )

local jumpPeriod = 500	--in ms
local jumpHeight = 100

--create a picGroup to manage the order of the pictures in the game
local picGroup = display.newGroup( )

local function handleButtonEvent( event )
	if ("ended" == event.phase) then
		changeBackground()
	end
end

--add a button
local button1 = widget.newButton(
    {
    	left = display.contentWidth - 70, 
    	top = display.contentHeight - 70,
        width = 50,
        height = 50,
        defaultFile = "pic/buttonReturn_default.png",
        overFile = "pic/buttonReturn_over.png",
        onEvent = handleButtonEvent
    }
)

--add background image
local backgroundList = {}
local bgPicAmount = 10
for i = 1,bgPicAmount do
	table.insert( backgroundList, "pic/bg".. i ..".png" )
end
local background = display.newImageRect(backgroundList[1], display.contentWidth * 1.2 , display.contentHeight * 1.2)
background.x = display.contentWidth / 2
background.y = display.contentHeight / 2
background.currentIndex = 1

picGroup:insert(background)

-- add floor
-- local floor = display.newImageRect( "pic/floor.png", display.contentWidth * 1.2, 450)
-- floor.x = display.contentWidth / 2
-- floor.y = display.contentHeight
-- physics.addBody( floor, "static", { bounce = 0.2 } )

--add ballon
local  ballon = display.newImage("pic/ballon_blue.png")
ballon.x = display.contentWidth / 2
ballon.y = display.contentHeight * 0.65
ballon.isImaged = true

picGroup:insert(ballon)
--physics.addBody( ballon, { bounce = .8} )

--add a smile
local smile = display.newImageRect("pic/smile.png", 100, 100)
smile.x = display.contentWidth / 2
smile.y = display.contentHeight * 0.7
physics.addBody( smile, "static")

picGroup:insert(smile)

function onTouch(event)
-- 	if (event.phase == "began") then
-- 		background:removeSelf()
-- 		background = nil
-- 		background = display.newImageRect(backgroundList[math.random(1,#backgroundList)], display.contentWidth * 1.2, display.contentHeight * 1.2)
-- 		background.x = display.contentWidth / 2
-- 		background.y = display.contentHeight / 2
-- 		background:toBack()
		-- if (ballon.isImaged) then
		-- 	ballon:removeSelf( )
		-- 	ballon.isImaged = false
		-- else
		-- 	ballon = display.newImage("pic/ballon_blue.png")
		-- 	ballon.x = display.contentWidth / 2
		-- 	ballon.y = display.contentHeight * 0.65
		-- 	ballon.isImaged = true
		-- end
-- 	end
end

Runtime:addEventListener( "touch", onTouch )

function moveRandomly()
	transition.to( ballon, 
		{x=math.random(0, display.contentWidth) ,
		y=math.random(0, display.contentHeight),
		transition = easing.inOutQuad,
		time = 1000,
		onComplete = moveRandomly} 
		)
end

function floatUpward()
	transition.to( ballon, 
		{x=display.contentWidth / 2,
		y=ballon.y - jumpHeight,
		transition = easing.outQuad,
		time = jumpPeriod,
		onComplete = floatDownward} 
		)
end
function floatDownward()
	transition.to( ballon, 
		{x=display.contentWidth / 2,
		y=ballon.y + jumpHeight,
		transition = easing.inQuad,
		time = jumpPeriod,
		onComplete = floatUpward} 
		)
end

function jumpUpward()
	transition.to( smile, 
		{x=display.contentWidth / 2,
		y=smile.y - jumpHeight,
		transition = easing.outQuad,
		time = jumpPeriod,
		onComplete = function()
			jumpDownward()
			end} 
		)
end

function jumpDownward()
	transition.to( smile, 
		{x=display.contentWidth / 2,
		y=smile.y + jumpHeight,
		transition = easing.inQuad,
		time = jumpPeriod,
		onComplete = function()
			jumpUpward()
		end} 
		)
end

function changeBackground()
	local currentIndex = background.currentIndex
	if (currentIndex >= bgPicAmount) then
		currentIndex = 1
	else 
		currentIndex = currentIndex + 1
	end
	background:removeSelf()
	background = nil
	background = display.newImageRect(backgroundList[currentIndex], display.contentWidth * 1.2, display.contentHeight * 1.2)
	background.x = display.contentWidth / 2
	background.y = display.contentHeight / 2
	background:toBack()
	background.currentIndex = currentIndex	
end


moveRandomly()
jumpUpward()