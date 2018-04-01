import os
import os.path
import shutil

folders = [
"red", 
"green", 
"blue", 
"purple"
]
for folder in folders:
    print(folder)
    dir = os.path.join('/',folder)
    #dir = 'folders'
    if os.path.exists(dir):
        shutil.rmtree(dir)
    os.makedirs(dir)
    os.chmod(dir, 0o775)
    os.chown(dir, 1000, 1000)