import os
import shutil

dir = '/test/chicken/popcorn'
if os.path.exists(dir):
    shutil.rmtree(dir)
os.makedirs(dir)


#os.makedirs('/test/one')
#os.makedirs('/test/two')
#os.chmod('/test', 0775 )