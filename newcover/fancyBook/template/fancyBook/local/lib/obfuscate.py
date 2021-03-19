import os
import random
import string
import re
def random_possible_character(stringLength=30):
    alphabet = string.ascii_uppercase + string.ascii_lowercase + string.digits
    possible_characters = ""  
    return ''.join(random.choice(alphabet) for i in range(stringLength))
#print("Random String is ", random_possible_character())
#print("Random String is ", random_possible_character(8))
#print("Random String is ", random_possible_character(10))
file_suffix = "min"
possible_characters = string.ascii_uppercase + string.ascii_lowercase + string.digits
pattern = re.compile(r'^(.+)\.'+file_suffix+'\.sty$')
content_folder = os.getcwd()
for file_in_dir in os.scandir(content_folder):
    file_name_complete = file_in_dir.name 
    (file_name, file_format) = os.path.splitext(file_in_dir.name)
    #print(file_name_complete + " " + file_format!=".py")
    if pattern.match(file_in_dir.name) == None and file_format!=".py" and os.path.isfile(file_in_dir.name):
        original_file = open(file_name_complete, 'r')
        obfuscated_file = open("obfuscateFiles/"+file_name+'.'+file_suffix+file_format, 'w')
        for line_documment in original_file:
            line_obfuscate = ""
            for character in line_documment:
                if(possible_characters.find(character) != -1):
                    line_obfuscate += "^^"+character.encode('utf-8').hex()
                else:
                    line_obfuscate += character
            obfuscated_file.write(line_obfuscate)
            #print(line_obfuscate)
        obfuscated_file.close()
        original_file.close()
        print("Se obfusco "+file_name_complete)   
    
