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
        pass
        
    def debian_compat(self):
        self.install("libtbb2 zlib1g libgomp1")
        self.install("libswscale4 libjpeg62 libjpeg8 libpng16-16 libtiff5 libavformat57 libilmbase12 libopenexr22")

    def redhat_compat(self):
        pass

    def fedora(self):
        pass

    def macosx(self):
        pass

    def common_last(self):
        pass

#----------------------------------------------------------------------------------------------

parser = argparse.ArgumentParser(description='Set up system for RedisEdgeVision build.')
parser.add_argument('-n', '--nop', action="store_true", help='no operation')
args = parser.parse_args()

RedisGearsSetup(nop = args.nop).setup()
