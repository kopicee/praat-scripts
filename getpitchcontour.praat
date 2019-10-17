# Praat script to get pitch contour of a Sound object and output in CSV format.
# This is done by breaking up the sound object into several "time windows" and
# taking the average pitch for each time window.
#
# Each line in the CSV output starts with the name of the Sound object, followed
# by a series of pitch values in Hz.
#
# To use this script: 
#   1. Open the Sound object of interest in Praat.
#   2. Select the Sound objects that you want to sample the pitch for. You can
#      select multiple Sound objects.
#   3. From the menu bar at the top click Praat > New Praat script
#   4. Paste everything here into the script editor window.
#   5. Press Ctrl-R (or Command-R on Mac I think?) to run the script.
#   6. Save the text in the output ("Praat Info") as a normal text file (paste
#      into notepad) and save as .csv (e.g. pitchtrace.csv)
#   7. You can now open the .csv file in R using read.csv('pitchtrace.csv')


# Setting: num. of points in each Sound object that we want to take the pitch of
numPitchPoints = 5

# Print a blank line with writeInfoLine to clear the program output
writeInfoLine: ""

# Tell Praat to "remember" our current selection of Sound objects. This is 
# because we are changing the selection to Pitch objects later on, so we are
# going to lose track of the Sound objects if we don't remember them like this.
# Praat stores the Sound objects in a list (marked by the # in the variable name)
sounds# = selected# ("Sound")

# Iterate over each Sound object in the list
for n to size (sounds#)
    # Select the nth Sound from the list
    selectObject: sounds#[n]

    # Get the name of the current Sound
    soundName$ = selected$ ()

    # Test if name is untitled
    if soundName$ <> "Sound untitled"
        # Write it at the start of our current line of output
        appendInfo: soundName$

        # Remember the total duration of this Sound
        totalDuration = Get total duration

        # Create Pitch object from this Sound
        # The 3 arguments below are time step (sec), pitch floor (Hz), and 
        # pitch ceiling (Hz)
        To Pitch: 0.1, 75.0, 600.0

        # Iterate over each point of time in the Pitch object
        for idx from 0 to (numPitchPoints - 1)
            # Calculate a time window defined by start and end bounds
            windowStart = idx / numPitchPoints * totalDuration
            windowEnd = (idx + 1) / numPitchPoints * totalDuration

            # Get mean pitch for window in Hz; if no pitch detected (undefined)
            # then record pitch with special value of -1 (to handle in R later)
            pitch = Get mean: windowStart, windowEnd, "Hertz"
            if pitch == undefined
                pitch = -1
            endif

            # Add a comma before the pitch output (this is useful later in R)
            # Write the pitch to the current line of our program output
            appendInfo: ","
            appendInfo: pitch
        endfor

        #   Remove pitch object since we are done
        Remove

        # Start a new line of output for the next Sound object
        appendInfoLine: ""
    endif
endfor
