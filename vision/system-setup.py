#!/usr/bin/env python3

import sys
import os
import argparse

# deps/readies in Docker filesystem terms
sys.path.insert(0, os.path.join(os.path.dirname(__file__), "deps/readies"))
import paella

#----------------------------------------------------------------------------------------------

class RedisEdgeVisionSetup(paella.Setup):
    def __init__(self, nop=False):
        paella.Setup.__init__(self, nop)

    def common_first(self):
        pass
        
    def debian_compat(self):
        # self.install("python3-numpy python3-opencv python3-pil python3-imageio")
        self.install("libtbb2 zlib1g libgomp1")
        self.install("libjpeg62 libpng16-16 libtiff5")
        # self.install("libswscale5 libjpeg62-turbo libpng16-16 libtiff5 libavformat58 libilmbase23 libopenexr23")
        
    def ubuntu(self):
        if self.osnick == 'focal':
            self.install("libswscale5 libavformat58 libilmbase24 libopenexr24")
        else:
            self.install("libswscale4 libavformat57 libilmbase12 libopenexr22")

    def redhat_compat(self):
        pass

    def fedora(self):
        pass

    def macos(self):
        pass

    def common_last(self):
        pass

#----------------------------------------------------------------------------------------------

parser = argparse.ArgumentParser(description='Set up system for RedisEdgeVision.')
parser.add_argument('-n', '--nop', action="store_true", help='no operation')
args = parser.parse_args()

RedisEdgeVisionSetup(nop = args.nop).setup()
