#!/usr/bin/env python2

import sys
import os
import popen2
import argparse

sys.path.insert(0, os.path.join(os.path.dirname(__file__), "deps/readies"))
import paella

#----------------------------------------------------------------------------------------------

class RedisGearsSetup(paella.Setup):
    def __init__(self, nop=False):
        paella.Setup.__init__(self, nop)

    def common_first(self):
        self.install("wget unzip git")
        self.install("cmake yasm")

        self.setup_pip()
        self.pip_install("wheel")
        self.pip_install("setuptools --upgrade")
        self.pip_install("virtualenv")
        
    def debian_compat(self):
        self.install("build-essential")
        self.install("pkg-config")
        self.install("libtbb2 libtbb-dev")
        self.install("zlib1g-dev")
        self.install("libjpeg-dev libpng-dev libtiff-dev libavformat-dev libswscale-dev")
        # self.install("libpq-dev")

    def redhat_compat(self):
        pass

    def fedora(self):
        pass

    def macosx(self):
        pass

    def common_last(self):
        # self.pip_install("numpy")
        pass

#----------------------------------------------------------------------------------------------

parser = argparse.ArgumentParser(description='Set up system for RedisEdgeVision build.')
parser.add_argument('-n', '--nop', action="store_true", help='no operation')
args = parser.parse_args()

RedisGearsSetup(nop = args.nop).setup()
