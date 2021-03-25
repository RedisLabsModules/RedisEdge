#!/usr/bin/env python3

import sys
import os
import argparse

# deps/readies in Docker filesystem terms
HERE = ROOT = os.path.abspath(os.path.dirname(__file__))
READIES = os.path.join(ROOT, "deps/readies")
sys.path.insert(0, READIES)
import paella

#----------------------------------------------------------------------------------------------

class RedisEdgeVisionLibsSetup(paella.Setup):
    def __init__(self, nop=False):
        paella.Setup.__init__(self, nop)

    def common_first(self):
        self.install("wget unzip git openssl")
        self.install("yasm")

        self.pip_install("wheel")
        self.pip_install("setuptools --upgrade")
        self.pip_install("virtualenv")
        
    def debian_compat(self):
        self.run("%s/bin/getgcc" % READIES)
        self.install("pkg-config")
        self.install("libtbb2 libtbb-dev")
        self.install("zlib1g-dev")
        self.install("libjpeg-dev libpng-dev libtiff-dev libavformat-dev libswscale-dev")
        # self.install("libpq-dev")

    def redhat_compat(self):
        pass

    def fedora(self):
        pass

    def macos(self):
        pass

    def common_last(self):
        self.run("%s/bin/getcmake" % READIES)
        # self.pip_install("numpy")

#----------------------------------------------------------------------------------------------

parser = argparse.ArgumentParser(description='Set up system for RedisEdgeVisionLibs.')
parser.add_argument('-n', '--nop', action="store_true", help='no operation')
args = parser.parse_args()

RedisEdgeVisionLibsSetup(nop = args.nop).setup()
