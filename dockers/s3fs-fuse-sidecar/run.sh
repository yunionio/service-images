#!/bin/bash

error_exit() {
    local msg="$1"
    echo "$msg"
    exit 1
}

[[ -z "${MOUNTPOINT}" ]] && error_exit "MOUNTPOINT is not set"

mkdir -p $MOUNTPOINT

[[ -z "${S3_ACCESSKEY}" ]] && error_exit "S3_ACCESSKEY is not set"
[[ -z "${S3_SECRETKEY}" ]] && error_exit "S3_SECRETKEY is not set"

TMP_PASSWD_FILE=/etc/s3-passwd
echo $S3_ACCESSKEY:$S3_SECRETKEY > $TMP_PASSWD_FILE && chmod 400 $TMP_PASSWD_FILE
FUSE_OPTS="$FUSE_OPTS -o passwd_file=${TMP_PASSWD_FILE}"

[[ -z "${S3_UID}" ]] || FUSE_OPTS="$FUSE_OPTS -o uid=${S3_UID}"
[[ -z "${S3_GID}" ]] || FUSE_OPTS="$FUSE_OPTS -o gid=${S3_GID}"
[[ -z "${AUTOROLE}" ]] || FUSE_OPTS="$FUSE_OPTS -o iam_role=auto"
[[ -z "${ALLOWEMPTY}" ]] || FUSE_OPTS="$FUSE_OPTS -o nonempty"
[[ -z "${ALLOWOTHERS}" ]] || FUSE_OPTS="$FUSE_OPTS -o allow_other"
[[ -z "${S3_URL}" ]] || FUSE_OPTS="$FUSE_OPTS -o url=${S3_URL}"

FUSE_OPTS="$FUSE_OPTS -o use_path_request_style"

echo Mounting $BUCKET  on $MOUNTPOINT with $FUSE_OPTS...
exec s3fs $BUCKET $MOUNTPOINT $FUSE_OPTS -o use_cache=/tmp # -f
