#!/bin/sh

# misc

MONGO_VERSION=3.6.2
GO_VERSION=1.9.1
apt-get update -y
apt-get install wget git binutils -y
wget https://storage.googleapis.com/golang/go$GO_VERSION.linux-amd64.tar.gz -P /usr/local
tar -C /usr/local -xzf /usr/local/go$GO_VERSION.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin

# mongotools
git clone https://github.com/mongodb/mongo-tools /mongo-tools
cd /mongo-tools
git checkout tags/r$MONGO_VERSION
TOOLS_PKG='github.com/mongodb/mongo-tools'
rm -rf .gopath/
mkdir -p .gopath/src/"$(dirname "${TOOLS_PKG}")"
ln -sf `pwd` .gopath/src/$TOOLS_PKG
export GOPATH=`pwd`/.gopath:`pwd`/vendor

go build -o /usr/bin/bsondump bsondump/main/bsondump.go
go build -o /usr/bin/mongoimport mongoimport/main/mongoimport.go
go build -o /usr/bin/mongoexport mongoexport/main/mongoexport.go
go build -o /usr/bin/mongodump mongodump/main/mongodump.go
go build -o /usr/bin/mongorestore mongorestore/main/mongorestore.go
go build -o /usr/bin/mongostat mongostat/main/mongostat.go
go build -o /usr/bin/mongofiles mongofiles/main/mongofiles.go
go build -o /usr/bin/mongooplog mongooplog/main/mongooplog.go
go build -o /usr/bin/mongotop mongotop/main/mongotop.go

# purge
#strip /usr/bin/mongosniff
strip /usr/bin/bsondump
strip /usr/bin/mongoimport
strip /usr/bin/mongoexport
strip /usr/bin/mongodump
strip /usr/bin/mongorestore
strip /usr/bin/mongostat
strip /usr/bin/mongofiles
strip /usr/bin/mongooplog
strip /usr/bin/mongotop
apt-get -y --purge autoremove  wget git binutils
rm -rf /mongo-tools
rm -rf /usr/local/go
rm -f /usr/local/go$GO_VERSION.linux-amd64.tar.gz
