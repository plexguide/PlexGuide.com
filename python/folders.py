import os
import os.path
import shutil

dir = '/test/chicken/popcorn'
if os.path.exists(dir):
    shutil.rmtree(dir)
os.makedirs(dir)

################ Goal is to print 4 directories /red /green /blue /purple
colors = [
"red", 
"green", 
"blue", 
"purple"
]
for color in colors:
    dir = os.path.join('/', 'colors')
    #dir = 'colors'
    if os.path.exists(dir):
        shutil.rmtree(dir)
    os.makedirs(dir)
    print(color)