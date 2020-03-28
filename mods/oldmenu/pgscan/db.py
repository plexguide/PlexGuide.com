import logging
import os

from peewee import DeleteQuery
from peewee import Model, SqliteDatabase, CharField, IntegerField

import config

logger = logging.getLogger("DB")

# Config
conf = config.Config()

db_path = conf.settings['queuefile']
database = SqliteDatabase(db_path, threadlocals=True)


class BaseQueueModel(Model):
    class Meta:
        database = database


class QueueItemModel(BaseQueueModel):
    scan_path = CharField(max_length=256, unique=True, null=False)
    scan_for = CharField(max_length=64, null=False)
    scan_section = IntegerField(null=False)
    scan_type = CharField(max_length=64, null=False)


def create_database(db, db_path):
    if not os.path.exists(db_path):
        db.create_tables([QueueItemModel])
        logger.info("Created database tables")


def connect(db):
    if not db.is_closed():
        return False
    return db.connect()


def init(db, db_path):
    if not os.path.exists(db_path):
        create_database(db, db_path)
    connect(db)


def get_next_item():
    item = None
    try:
        item = QueueItemModel.get()
    except Exception:
        # logger.exception("Exception getting first item to scan: ")
        pass
    return item


def exists_file_root_path(file_path):
    items = get_all_items()
    if '.' in file_path:
        dir_path = os.path.dirname(file_path)
    else:
        dir_path = file_path

    for item in items:
        if dir_path.lower() in item['scan_path'].lower():
            return True, item['scan_path']
    return False, None


def get_all_items():
    items = []
    try:
        for item in QueueItemModel.select():
            items.append({'scan_path': item.scan_path,
                          'scan_for': item.scan_for,
                          'scan_type': item.scan_type,
                          'scan_section': item.scan_section})
    except Exception:
        logger.exception("Exception getting all items from database: ")
        return None
    return items


def get_queue_count():
    count = 0
    try:
        count = QueueItemModel.select().count()
    except Exception:
        logger.exception("Exception getting queued item count from database: ")
    return count


def remove_item(scan_path):
    try:
        return DeleteQuery(QueueItemModel).where(QueueItemModel.scan_path == scan_path).execute()
    except Exception:
        logger.exception("Exception deleting %r from database: ", scan_path)
        return False


def add_item(scan_path, scan_for, scan_section, scan_type):
    item = None
    try:
        return QueueItemModel.create(scan_path=scan_path, scan_for=scan_for, scan_section=scan_section,
                                     scan_type=scan_type)
    except AttributeError as ex:
        return item
    except Exception:
        pass
        # logger.exception("Exception adding %r to database: ", scan_path)
    return item


def queued_count():
    try:
        return QueueItemModel.select().count()
    except Exception:
        logger.exception("Exception retrieving queued count: ")
    return 0


# Init
init(database, db_path)
