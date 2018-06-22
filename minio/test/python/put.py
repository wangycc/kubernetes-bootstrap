#!/bin/env python
from minio import Minio
from minio.error import ResponseError

import os 
import tempfile


IPADDR = "10.102.1.140:9000"
ACCESS_KEY = "minio"
SECRETKEY = "miniostorage"


minioClient = Minio(IPADDR,
              access_key=ACCESS_KEY,
              secret_key=SECRETKEY,
              secure=False)
try:
    print(minioClient.fput_object('mybucket', 'myobject', '/tmp/test'))
except ResponseError as err:
    print(err)

