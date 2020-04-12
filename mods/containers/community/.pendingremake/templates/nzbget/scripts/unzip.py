#!/usr/bin/env python
#
##############################################################################
### NZBGET SCAN SCRIPT                                          ###

# Unzips zipped nzbs.
#
# NOTE: This script requires Python to be installed on your system.

##############################################################################
### OPTIONS                                                                ###
### NZBGET SCAN SCRIPT                                          ###
##############################################################################

import os, zipfile, tarfile, gzip, pickle, datetime, re, struct, locale
import rarfile.rarfile as rarfile

from gzip import FEXTRA, FNAME

if 'nt' == os.name:
    import ctypes

    class WinEnv:
        def __init__(self):
            pass

        @staticmethod
        def get_environment_variable(name):
            name = unicode(name)  # ensures string argument is unicode
            n = ctypes.windll.kernel32.GetEnvironmentVariableW(name, None, 0)
            result = None
            if n:
                buf = ctypes.create_unicode_buffer(u'\0'*n)
                ctypes.windll.kernel32.GetEnvironmentVariableW(name, buf, n)
                result = buf.value
            return result

        def __getitem__(self, key):
            return self.get_environment_variable(key)

        def get(self, key, default=None):
            r = self.get_environment_variable(key)
            return r if r is not None else default

    env_var = WinEnv()
else:
    class LinuxEnv(object):
        def __init__(self, environ):
            self.environ = environ

        def __getitem__(self, key):
            v = self.environ.get(key)
            try:
                return v.decode(SYS_ENCODING) if isinstance(v, str) else v
            except (UnicodeDecodeError, UnicodeEncodeError):
                return v

        def get(self, key, default=None):
            v = self[key]
            return v if v is not None else default

    env_var = LinuxEnv(os.environ)


SYS_ENCODING = None
try:
    locale.setlocale(locale.LC_ALL, '')
except (locale.Error, IOError):
    pass
try:
    SYS_ENCODING = locale.getpreferredencoding()
except (locale.Error, IOError):
    pass
if not SYS_ENCODING or SYS_ENCODING in ('ANSI_X3.4-1968', 'US-ASCII', 'ASCII'):
    SYS_ENCODING = 'UTF-8'


filename = env_var.get('NZBNP_FILENAME')
if re.search(r"\.tar\.gz$", filename, flags=re.I) is None:
    ext = os.path.splitext(filename)[1].lower()
else:
    ext = '.tar.gz'
cat = env_var.get('NZBNP_CATEGORY')
dir = env_var.get('NZBNP_DIRECTORY')
prio = env_var.get('NZBNP_PRIORITY')
top = env_var.get('NZBNP_TOP')
pause = env_var.get('NZBNP_PAUSED')
if 'NZBNP_DUPEKEY' in os.environ:
    dupekey = env_var.get('NZBNP_DUPEKEY')
    dupescore = env_var.get('NZBNP_DUPESCORE')
    dupemode = env_var.get('NZBNP_DUPEMODE')
else:
    dupekey = None
    dupescore = None
    dupemode = None

tmp_zipinfo = os.path.join(os.environ.get('NZBOP_TEMPDIR'), r'nzbget\unzip_scan\info')
nzb_list = []

def read_gzip_info(gzipfile):
    gf = gzipfile.fileobj
    pos = gf.tell()

    # Read archive size
    gf.seek(-4, 2)
    size = struct.unpack('<I', gf.read())[0]

    gf.seek(0)
    magic = gf.read(2)
    if magic != '\037\213':
        raise IOError, 'Not a gzipped file'

    method, flag, mtime = struct.unpack("<BBIxx", gf.read(8))

    if not flag & FNAME:
        # Not stored in the header, use the filename sans .gz
        gf.seek(pos)
        fname = gzipfile.name
        if fname.endswith('.gz'):
            fname = fname[:-3]
        return fname, size

    if flag & FEXTRA:
        # Read & discard the extra field, if present
        gf.read(struct.unpack("<H", gf.read(2)))

    # Read a null-terminated string containing the filename
    fname = []
    while True:
        s = gf.read(1)
        if not s or s=='\000':
            break
        fname.append(s)

    gf.seek(pos)
    return ''.join(fname), size

def save_obj(obj, name):
    tp = os.path.dirname(name)
    if not os.path.exists(tp):
        try:
            os.makedirs(tp)
        except:
            print "Error creating Dir " + tp
            return
    try:
        with open(name, 'wb') as f:
            pickle.dump(obj, f, pickle.HIGHEST_PROTOCOL)
    except:
        print "Error saving: " + name

def load_obj(name):
    if os.path.isfile(name):
        try:
            with open(name, 'rb') as f:
                return pickle.load(f)
        except:
            print "Error loading " + name
            return None
    else:
        return None

def save_nzb_list():
    if nzb_list:
        save_obj(nzb_list, tmp_zipinfo)
    else:
        if os.path.isfile(tmp_zipinfo):
            try:
                os.unlink(tmp_zipinfo)
            except:
                print "Error deleting " + tmp_zipinfo

def load_nzb_list():
    global nzb_list
    nzb_list = load_obj(tmp_zipinfo)
    if nzb_list:
        now = datetime.datetime.now()
        o_l = len(nzb_list)
        nzb_list[:] = [el for el in nzb_list if (now - el[8]).days < 1]
        if nzb_list is not None and o_l != len(nzb_list):
            save_nzb_list()

def get_files(zf):
    zi = zf.infolist()
    zi[:] = [el for el in zi if os.path.splitext(el.filename)[1].lower() == '.nzb']
    return zi

def get_tar_files(tf):
    ti = tf.getmembers()
    ti[:] = [el for el in ti if el.isfile() and os.path.splitext(el.name)[1].lower() == '.nzb']
    return ti

def get_rar_files(rf):
    ri = rf.infolist()
    ri[:] = [el for el in ri if os.path.splitext(el.filename)[1].lower() == '.nzb']
    return ri

def remove_filename():
    try:
        os.unlink(filename)
    except:
        print "Error deleting " + filename

if ext == '.zip':
    load_nzb_list()
    zipf = zipfile.ZipFile(filename, mode='r')
    zf = get_files(zipf)
    if zf:
        zipf.extractall(path = dir, members = zf)
        now = datetime.datetime.now()
        for z in zf:
            if nzb_list:
                nzb_list.append([z.filename, cat, prio, top, pause, dupekey, dupescore, dupemode, now])
            else:
                nzb_list = [[z.filename, cat, prio, top, pause, dupekey, dupescore, dupemode, now]]
        save_nzb_list()
    zipf.close()

    remove_filename()

elif ext in ['.tar.gz', '.tar', '.tgz']:
    load_nzb_list()
    tarf = tarfile.open(filename, mode='r')
    tf = get_tar_files(tarf)
    if tf:
        tarf.extractall(path = dir, members = tf)
        now = datetime.datetime.now()
        for z in tf:
            if nzb_list:
                nzb_list.append([z.name, cat, prio, top, pause, dupekey, dupescore, dupemode, now])
            else:
                nzb_list = [[z.name, cat, prio, top, pause, dupekey, dupescore, dupemode, now]]
        save_nzb_list()
    tarf.close()

    remove_filename()

elif ext == '.gz':
    load_nzb_list()
    gzf =gzip.open(filename, mode='rb')
    out_filename, size = read_gzip_info(gzf)
    if out_filename and os.path.splitext(out_filename)[1].lower() == '.nzb':
        with open(os.path.join(os.path.dirname(filename), out_filename), 'wb') as outf:
            outf.write(gzf.read())
            outf.close()

        if gzf and out_filename:
            now = datetime.datetime.now()
            if nzb_list:
                nzb_list.append([os.path.basename(out_filename), cat, prio, top, pause, dupekey, dupescore, dupemode, now])
            else:
                nzb_list = [[os.path.basename(out_filename), cat, prio, top, pause, dupekey, dupescore, dupemode, now]]
            save_nzb_list()
    gzf.close()

    remove_filename()

elif ext == '.rar':
    load_nzb_list()
    rarf = rarfile.RarFile(filename, mode='r')
    rf = get_files(rarf)
    if rf:
        rarf.extractall(path = dir, members = rf)
        now = datetime.datetime.now()
        for r in rf:
            if nzb_list:
                nzb_list.append([r.filename, cat, prio, top, pause, dupekey, dupescore, dupemode, now])
            else:
                nzb_list = [[r.filename, cat, prio, top, pause, dupekey, dupescore, dupemode, now]]
        save_nzb_list()
    rarf.close()

    remove_filename()

elif ext == '.nzb' and os.path.exists(tmp_zipinfo):
    load_nzb_list()
    if nzb_list:
        ni = None
        f_l = os.path.basename(filename).lower()
        for i, nf in enumerate(nzb_list):
            if os.path.basename(nf[0]).lower() == f_l:
                ni = i
                break
        if ni is not None:
            print "[NZB] CATEGORY=" + str(nzb_list[ni][1])
            print "[NZB] PRIORITY=" + str(nzb_list[ni][2])
            print "[NZB] TOP=" + str(nzb_list[ni][3])
            print "[NZB] PAUSED=" + str(nzb_list[ni][4])
            if dupekey is not None:
                print "[NZB] DUPEKEY=" + str(nzb_list[ni][5])
                print "[NZB] DUPESCORE=" + str(nzb_list[ni][6])
                print "[NZB] DUPEMODE=" + str(nzb_list[ni][7])
            del nzb_list[ni]
            save_nzb_list()
