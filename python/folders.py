import os
import os.path
import shutil

paths = [
"red1", 
"green1", 
"blue1", 
"purple1"
]
for path in paths:
	print(path)
    dir = os.path.join('/',path)
    if os.path.exists(dir):
        shutil.rmtree(dir)
    os.makedirs(dir)