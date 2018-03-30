local composer = require( "composer" )
local widget = require( "widget" )

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called
-- -----------------------------------------------------------------------------------------------------------------

-- Local forward references should go here
local sceneGroup

local bg, bgTransparentRect
local rascal
local buttonReplaySmall, buttonReplayLarge
local comboText, comboValue
local stopWatchText, stopWatchValue
local resultTitle
local rascalStatus
local rascalStatusEnum = {
    smileTouched = "smileTouched",
    smileUntouched = "smileUntouched",
    bombOccur = "bombOccur"
}

local spawnTimer, updateTimer, stopWatchTimer
local buttonSound1, buttonSound2, boomSound

local screenEdge = 90
local rascalEdgeSize = 80
local bombEdgeSize = 100
local bombOccurRate = .2

-- -------------------------------------------------------------------------------

-- local function bgPathGenerator()
--     local bgAmount = 10
--     return "pic/bg" .. math.random(1, bgAmount) .. ".png"
-- end

local function generateComboText( combo_value )
    return "Combo: " .. combo_value
end

local function generateStopWatchText( stopWatch_value )
    local min = math.floor(stopWatch_value / 60)
    local sec =  stopWatch_value - min * 60
    if (sec < 10) then
        return min .. ":0" .. sec
    else
        return min .. ":" .. sec
    end
end

local function comboUpdate( option )
    
    if (option == "increment") then
        comboValue = comboValue + 1
    elseif (option == "decrement") then
        if (comboValue > 0) then
            comboValue = comboValue - 1
        end
    end

    comboText.text = generateComboText( comboValue )
end

local function replay()
    composer.removeScene( "sceneGame" )
    local options = {
        effect = "fade",
        time = 500
    }
    composer.gotoScene( "sceneMenu" , options)
end

local function lose()
    timer.cancel( spawnTimer )
    timer.cancel( updateTimer )
    timer.cancel( stopWatchTimer )

    --disable the smaller replay button
    buttonReplaySmall:setEnabled( false )
    buttonReplayLarge = widget.newButton(
        {
            x = display.contentCenterX, 
            y = display.contentCenterY + 120,
            width = 90,
            height = 90,
            defaultFile = "pic/buttonReturn_default.png",
            overFile = "pic/buttonReturn_over.png",
            onPress = function ()
                audio.play( buttonSound1 )
            end,
            onRelease = function ()
                timer.cancel( spawnTimer )
                timer.cancel( updateTimer )
                timer.cancel( stopWatchTimer )
                replay()
            end
        }
    )
    sceneGroup:insert( buttonReplayLarge )

    --display the losing view
    bgTransparentRect = display.newRect( -30, -30, display.contentWidth * 1.2, display.contentHeight * 1.2)
    bgTransparentRect.x, bgTransparentRect.y = display.contentCenterX, display.contentCenterY
    bgTransparentRect:setFillColor(0, .5)
    sceneGroup:insert( bgTransparentRect )

    resultTitle = display.newText( "You Lose", display.contentCenterX, display.contentCenterY , "Arial" , 70)
    resultTitle:setFillColor(1,0,0)
    sceneGroup:insert( resultTitle )

    --adjust the order of the objects
    rascal:toBack( )
    bg:toBack( )
    buttonReplayLarge:toFront( )

end

local function touchRascal()

    --store the position before change the image
    local tempX, tempY = rascal.x, rascal.y
    local tempType = rascal.type
    rascal:removeSelf()
    rascal = nil
    if(tempType == "smile") then
        
        --setting rascal status
        rascalStatus = rascalStatusEnum.smileTouched
        --play sound effect
        audio.play( buttonSound2 )

        rascal = display.newImageRect( "pic/nervous.png", rascalEdgeSize, rascalEdgeSize )
        rascal.x, rascal.y = tempX, tempY
        sceneGroup:insert( rascal )
        comboUpdate( "increment" )

    elseif (tempType == "bomb") then
        
        --play sound effect
        audio.play( boomSound )
        
        rascal = display.newImage( "pic/boom_red.png" )
        rascal.x, rascal.y = tempX, tempY
        sceneGroup:insert( rascal )
        lose()
    end
end

local function moveRandomly()

    if (rascalStatus == rascalStatusEnum.smileUntouched) then
        comboUpdate("decrement")
    end
    rascalStatus = rascalStatusEnum.smileUntouched

    if (rascal) then  
        rascal:removeSelf( )
        rascal = nil
    end
    if( math.random() > bombOccurRate ) then
        rascal = display.newImageRect( "pic/smile.png", rascalEdgeSize, rascalEdgeSize )
        rascal.type = "smile"
    else
        rascal = display.newImageRect( "pic/bomb.png", bombEdgeSize, bombEdgeSize )
        rascal.type = "bomb"
        rascalStatus = rascalStatusEnum.bombOccur
    end

    rascal.x, rascal.y = math.random(screenEdge, display.contentWidth - screenEdge), 
                        math.random(screenEdge, display.contentHeight - screenEdge)
    rascal:addEventListener( "tap", touchRascal )
    sceneGroup:insert( rascal )

end

local updateTimerFunc = function()
    if ( comboValue < 5 ) then
        spawnTimer._delay = 1200
    elseif ( comboValue < 10 ) then 
        spawnTimer._delay = 1000
    elseif ( comboValue < 15) then 
        spawnTimer._delay = 900
    elseif ( comboValue < 20) then
        spawnTimer._delay = 800
    elseif ( comboValue < 25) then
        spawnTimer._delay = 750
    elseif ( comboValue < 30) then
        spawnTimer._delay = 700
    elseif ( comboValue < 35) then
        spawnTimer._delay = 650
    elseif ( comboValue < 40) then
        spawnTimer._delay = 600
    elseif ( comboValue < 50) then
        spawnTimer._delay = 550
    elseif ( comboValue < 60) then
        spawnTimer._delay = 500
    elseif ( comboValue < 70) then
        spawnTimer._delay = 450
    elseif ( comboValue < 80) then
        spawnTimer._delay = 400
    elseif ( comboValue < 90) then
        spawnTimer._delay = 350
    else
        spawnTimer._delay = 300
    end
end

local function stopWatchTimerFunc()
    stopWatchValue = stopWatchValue + 1
    stopWatchText.text = generateStopWatchText( stopWatchValue )
end



-- "scene:create()"
function scene:create( event )

    sceneGroup = self.view

    -- Initialize the scene here
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.
end


-- "scene:show()"
function scene:show( event )

    sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen)
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen
        -- Insert code here to make the scene come alive
        -- Example: start timers, begin animation, play audio, etc.

        bg = display.newImageRect( "pic/bg3.png" , display.contentWidth * 1.2, display.contentHeight * 1.2 )
        bg.x, bg.y = display.contentCenterX, display.contentCenterY
        sceneGroup:insert( bg )

        --load sound effect
        buttonSound1 = audio.loadSound( "sound/button1.wav" )
        buttonSound2 = audio.loadSound( "sound/button2.wav" )
        boomSound = audio.loadSound( "sound/boom.mp3" )


        --Setup the text that showing the combo
        comboValue = 0
        comboText = display.newText( generateComboText(comboValue), display.contentWidth - 90 , 20 , "Arial" , 30 )
        comboText:setFillColor( 1,1,1 )
        sceneGroup:insert( comboText )

        --Setup the text that showing the stopWatch
        stopWatchValue = 0
        stopWatchText = display.newText( generateStopWatchText(stopWatchValue), 50 , display.contentHeight - 30 , "Arial" , 30 )
        stopWatchText:setFillColor( 1,1,1 )
        sceneGroup:insert( stopWatchText )

        --create rascal
        moveRandomly()

        --setup the return button
        buttonReplaySmall = widget.newButton(
            {
                left = 10, 
                top = 10,
                width = 50,
                height = 50,
                defaultFile = "pic/buttonReturn_default.png",
                overFile = "pic/buttonReturn_over.png",
                onPress = function ()
                    audio.play( buttonSound1 )
                end,
                onRelease = function ()
                    timer.cancel( spawnTimer )
                    timer.cancel( updateTimer )
                    timer.cancel( stopWatchTimer )
                    replay()
                end
            }
        )
        sceneGroup:insert( buttonReplaySmall )

        --start the spawnTimer which execute the moveRandomly() infinitely
        --until losing
        spawnTimer = timer.performWithDelay( 1200, moveRandomly, -1)
        --timer used to update spawnTimer
        updateTimer = timer.performWithDelay( 1000, updateTimerFunc , -1 )
        stopWatchTimer = timer.performWithDelay( 1000, stopWatchTimerFunc , -1 )
    end
end

-- "scene:hide()"
function scene:hide( event )

    sceneGroup = self.view

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

    sceneGroup = self.view

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