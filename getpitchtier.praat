# Praat script to get PitchTier of a Sound object in "spreadsheet" form.
# (Using the "Save as PitchTier spreadsheet file")
#
# To use this script: 
#   1. Open the Sound objects of interest in Praat.
#   2. Select the Sound objects that you want to sample the pitch for. You can
#      select multiple Sound objects.
#   3. From the menu bar at the top click Praat > New Praat script
#   4. Paste everything here into the script editor window.
#   5. Edit the output directory to where you want to save the PitchTiers.
#      If you don't define one, it will save the PitchTier files to wherever
#      your Praat program is installed.
#   6. Press Ctrl-R (or Command-R on Mac I think?) to run the script.
#   7. You can now open the .PitchTier file in R:
#          read.csv('sound.PitchTier', skip=3)
#      The first 3 lines of the PitchTier file are for error-checking. You can
#      just ignore them with skip=3 if you don't want to perform the checks.


# Setting: output dir
outputDir$ = ""

# Setting: num. of points in each Sound object that we want to take the pitch of
numPitchPoints = 5



# Print a blank line with writeInfoLine to clear the program output
writeInfoLine: ""

# Tell Praat to "remember" our current selection of Sound objects. This is 
# because we are changing the selection to Pitch objects later on, so we are
# going to lose track of the Sound objects if we don't remember them like this.
# Praat stores the Sound objects in a list (marked by the # in the variable name)
sounds# = selected# ("Sound")

if size (sounds#) == 0
    appendInfoLine: "(no Sound objects selected!)"
    exitScript()
endif

# Iterate over each Sound object in the list
for n to size (sounds#)
    # Select the nth Sound from the list
    selectObject: sounds#[n]

    # Get the name of the current Sound
    soundName$ = replace$(selected$ (), "Sound ", "", 1)

    # Test if name is untitled
    if soundName$ <> "Sound untitled"
        # Convert the Sound to a Manipulation, then extract the PitchTier.
        # See links at http://www.fon.hum.uva.nl/praat/manual/Manipulation.html
        
        # Args: time step (s), min pitch (Hz), max pitch (Hz)
        To Manipulation: 0.01, 75.0, 600.0
        manipulationName$ = selected$ ()
        Extract pitch tier

        # Save the pitch tier
        fileName$ = outputDir$ + soundName$ + ".PitchTier"
        Save as PitchTier spreadsheet file: fileName$
        appendInfo: fileName$

        # Remove the Manipulation and PitchTier objects since we are done
        Remove
        selectObject: manipulationName$
        Remove

        # Start a new line of output for the next Sound object
        appendInfoLine: ""
    endif
endfor

# Re-select original selection of Sound objects
for n to size (sounds#)
    # Select the nth Sound from the list
    selectObject: sounds#[n]
endfor
