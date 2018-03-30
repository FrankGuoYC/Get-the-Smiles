local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
local button
local bg
local clickPlayButtonSound

local function startUp()
    composer.gotoScene( "sceneStartUp" , {effect = "fade", time = 1000} )
end

local function gameStart()
    composer.gotoScene( "sceneGame" )
end

local function playClickPlaySound( soundHandle )
    local clickPlayButtonSound = audio.play( soundHandle )
end 


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
        bg = display.newImageRect( "pic/bg3.png" , display.contentWidth * 1.2, display.contentHeight * 1.2 )
        bg.x, bg.y = display.contentCenterX, display.contentCenterY
        sceneGroup:insert( bg )

        clickPlayButtonSound = audio.loadSound( "sound/button1.wav" )

        button = widget.newButton(
        {
            left = display.contentCenterX - 50, 
            top = display.contentCenterY - 50,
            width = 100,
            height = 100,
            defaultFile = "pic/buttonPlay_default.png",
            overFile = "pic/buttonPlay_over.png",
            onPress = function ()
                audio.play( clickPlayButtonSound )
            end,
            onRelease = gameStart
        }
        )
        sceneGroup:insert( button )


    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen)
        -- Insert code here to "pause" the scene
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view
    -- Insert code here to clean up the scene
    -- Example: remove display objects, save state, etc.
end


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-- -------------------------------------------------------------------------------

return scene