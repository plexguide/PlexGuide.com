#!/usr/bin/env python
#
# Title:      PGBlitz (Reference Title File)
# Maintainer: Admin9705
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
#
# Additions:  clinton-hall - https://github.com/Prinz23
################################################################################
import os
import sys

# NZBGet Exit Codes
NZBGET_POSTPROCESS_PARCHECK = 92
NZBGET_POSTPROCESS_SUCCESS = 93
NZBGET_POSTPROCESS_ERROR = 94
NZBGET_POSTPROCESS_NONE = 95

def is_sample(filePath, inputName, maxSampleSize, SampleIDs):
    # 200 MB in bytes
    SIZE_CUTOFF = int(maxSampleSize) * 1024 * 1024
    if os.path.getsize(filePath) < SIZE_CUTOFF:
        if 'SizeOnly' in SampleIDs:
            return True
        # Ignore 'sample' in files unless 'sample' in Torrent Name
        for ident in SampleIDs:
            if ident.lower() in filePath.lower() and not ident.lower() in inputName.lower():
                return True
    # Return False if none of these were met.
    return False

if not os.environ.has_key('NZBOP_SCRIPTDIR'):
    print "This script can only be called from NZBGet (11.0 or later)."
    sys.exit(0)

if os.environ['NZBOP_VERSION'][0:5] < '11.0':
    print "NZBGet Version %s is not supported. Please update NZBGet." % (str(os.environ['NZBOP_VERSION']))
    sys.exit(0)

print "Script triggered from NZBGet Version %s." % (str(os.environ['NZBOP_VERSION']))
status = 0
if os.environ.has_key('NZBPP_TOTALSTATUS'):
    if not os.environ['NZBPP_TOTALSTATUS'] == 'SUCCESS':
        print "Download failed with status %s." % (os.environ['NZBPP_STATUS'])
        status = 1

else:
    # Check par status
    if os.environ['NZBPP_PARSTATUS'] == '1' or os.environ['NZBPP_PARSTATUS'] == '4':
        print "Par-repair failed, setting status \"failed\"."
        status = 1

    # Check unpack status
    if os.environ['NZBPP_UNPACKSTATUS'] == '1':
        print "Unpack failed, setting status \"failed\"."
        status = 1

    if os.environ['NZBPP_UNPACKSTATUS'] == '0' and os.environ['NZBPP_PARSTATUS'] == '0':
        # Unpack was skipped due to nzb-file properties or due to errors during par-check

        if os.environ['NZBPP_HEALTH'] < 1000:
            print "Download health is compromised and Par-check/repair disabled or no .par2 files found. Setting status \"failed\"."
            print "Please check your Par-check/repair settings for future downloads."
            status = 1

        else:
            print "Par-check/repair disabled or no .par2 files found, and Unpack not required. Health is ok so handle as though download successful."
            print "Please check your Par-check/repair settings for future downloads."

# Check if destination directory exists (important for reprocessing of history items)
if not os.path.isdir(os.environ['NZBPP_DIRECTORY']):
    print "Nothing to post-process: destination directory", os.environ['NZBPP_DIRECTORY'], "doesn't exist. Setting status \"failed\"."
    status = 1

# All checks done, now launching the script.
if status == 1:
    sys.exit(NZBGET_POSTPROCESS_NONE)

mediaContainer = os.environ['NZBPO_MEDIAEXTENSIONS'].split(',')
SampleIDs = os.environ['NZBPO_SAMPLEIDS'].split(',')
for dirpath, dirnames, filenames in os.walk(os.environ['NZBPP_DIRECTORY']):
    for file in filenames:
        filePath = os.path.join(dirpath, file)
        fileName, fileExtension = os.path.splitext(file)
        if fileExtension in mediaContainer or ".*" in mediaContainer :  # If the file is a video file
            if is_sample(filePath, os.environ['NZBPP_NZBNAME'], os.environ['NZBPO_MAXSAMPLESIZE'], SampleIDs):  # Ignore samples
                print "Deleting sample file: ", filePath
                try:
                    os.unlink(filePath)
                except:
                    print "Error: unable to delete file", filePath
                    sys.exit(NZBGET_POSTPROCESS_ERROR)
sys.exit(NZBGET_POSTPROCESS_SUCCESS)
