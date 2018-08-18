import os

### clear screen
os.system('cls')

print("Welcome to the PG Version Deployment System!\n")

def readFile(filename):
    filehandle = open(filename)
    print filehandle.read()
    filehandle.close()

fileDir = os.path.dirname(os.path.realpath('__file__'))

#For accessing the file in the same folder
filename = os.path.join(fileDir, '/opt/plexguide/roles/versions/scripts/ver.list')
readFile(filename)

print("TO Quit, type >>> exit")
text = raw_input('Type the [PG Version] for Deployment! (All LowerCase): ')

#Actually Writing It
saveFile = open("/var/plexguide/pg.number", 'w')
saveFile.write(text)
saveFile.close()
