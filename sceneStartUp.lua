local composer = require( "composer" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here

-- -------------------------------------------------------------------------------
local bg
local title
local logo

local function toMenu()
    local options = {
        effect = "fade",
        time = 1000
    }
    composer.gotoScene( "sceneMenu" , options )
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
        bg = display.newImageRect( "pic/bg_startUp.png" , display.contentWidth * 1.2, display.contentHeight * 1.2 )
        bg.x, bg.y = display.contentCenterX, display.contentCenterY
        sceneGroup:insert(bg)

        title = display.newText( "Lua Project", display.contentCenterX, display.contentCenterY, "Arial" , 60 )
        sceneGroup:insert(title)

        logo = display.newText( "程式語言 第23組", display.contentWidth - 100, display.contentHeight - 40 ,"Microsoft JhengHei" , 20 )
        sceneGroup:insert(logo)

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.
        timer.performWithDelay( 1500, toMenu )
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