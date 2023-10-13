# Open the Plate solve file in read mode
with open('.\Images\output.txt', 'r') as file:
    # Read the entire contents of the file into a variable
    file_contents = file.read()

# Split the file contents variables into lines using the newline character '\n'
lines = file_contents.split('\n')

# Get the second line and store it as the right ascension of the image
calculatedRA = lines[1]

# Get the third line and store it as the declination of the image
calculatedDec = lines[2]

# Get the seventh line and store it as the rotation of the image
calculatedRot = lines[6]

# Pipe the image data to the beginning of the stellarium script by storing existing file contents as the variable 'existingFileContents' and prepending other data elements as variables
with open('.\StellariumScript.ssc', 'r') as file:
    existingFileContents = file.read()
    
strToCopyToNewFile = existingFileContents[existingFileContents.index("// Making"):]
 
with open('.\StellariumScript.ssc', 'w') as file:
    file.write(f"#include <VecMath.hpp>\n\n// Parameters from plate solver\nRAOfPlateSolved={calculatedRA}\ndecOfPlateSolved={calculatedDec}\nrotOfPlateSolved={calculatedRot}\n\n" + strToCopyToNewFile)