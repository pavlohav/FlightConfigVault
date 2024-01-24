-- Script to turn on a relay and move a servo during arming checks

local RELAY_PIN = 0   -- Set the relay pin number (Starts Count at 0)
local SERVO_CHANNEL = 9 -- Set the servo output channel (Starts Count at 0)
local SERVO_POSITION_DISARMED = 1000
local SERVO_POSITION_ARMED = 2000 -- Set servo position when armed in microseconds

function update()
    local current_arming_state = arming:is_armed()

    if current_arming_state ~= last_arming_state then
        if current_arming_state then
            -- Aircraft is armed, turn on the relay and move the servo to the armed position
            gcs:send_text(6, "Turning ON DVR")
            relay:on(RELAY_PIN)
            gcs:send_text(6, "Turning ON Strobe Lights")
            SRV_Channels:set_output_pwm_chan_timeout(SERVO_CHANNEL, SERVO_POSITION_ARMED, 3000)
        else
            -- Aircraft is not armed and arming is not in progress, turn off the relay
            gcs:send_text(6, "Turning OFF DVR")
            relay:off(RELAY_PIN)

            -- Optionally, reset the servo to a default position when disarmed
            gcs:send_text(6, "Turning OFF Strobe Lights")
            SRV_Channels:set_output_pwm_chan_timeout(SERVO_CHANNEL, SERVO_POSITION_DISARMED, 3000)
        end
        last_arming_state = current_arming_state
    end

    return update, 1000 -- Update every 1 second
end

return update()
